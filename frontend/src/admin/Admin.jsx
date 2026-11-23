import React, { useEffect, useState } from 'react'
import './admin.css'
import './articleAdmin.css'

const sections = {
  cars: {
    title: 'Автомобили', singular: 'автомобил',
    fields: [
      ['name', 'Модел', 'text'], ['year', 'Година', 'number'],
      ['price_eur', 'Цена (€)', 'number'], ['image', 'Основна снимка', 'image'],
      ['summary', 'Кратко описание', 'textarea', false],
      ['mileage_km', 'Пробег (км)', 'optional-number', false], ['engine', 'Двигател', 'text', false],
      ['power_hp', 'Мощност (к.с.)', 'optional-number', false], ['fuel', 'Гориво', 'text', false],
      ['transmission', 'Скоростна кутия', 'text', false], ['drivetrain', 'Задвижване', 'text', false],
      ['body_type', 'Тип купе', 'text', false], ['color', 'Цвят', 'text', false],
      ['vin', 'VIN', 'text', false], ['condition', 'Състояние', 'text', false],
      ['location', 'Местоположение', 'text', false],
      ['description', 'Подробно описание', 'textarea', false],
      ['features', 'Оборудване (по една характеристика на ред)', 'textarea', false],
      ['position', 'Ред', 'number'], ['is_active', 'Показва се', 'checkbox'],
    ],
  },
  reviews: {
    title: 'Отзиви', singular: 'отзив',
    fields: [
      ['name', 'Име на клиента', 'text'], ['vehicle', 'Автомобил', 'text'],
      ['text', 'Отзив', 'textarea'], ['image', 'Снимка', 'image'],
      ['position', 'Ред', 'number'], ['is_active', 'Показва се', 'checkbox'],
    ],
  },
  articles: {
    title: 'Статии', singular: 'статия',
    fields: [
      ['title', 'Заглавие', 'text'], ['excerpt', 'Кратко описание', 'textarea'],
      ['content', 'Съдържание', 'textarea'], ['is_published', 'Публикувана', 'checkbox'],
    ],
  },
  'article-settings': { title: 'Автоматични статии' },
  'website-settings': { title: 'Настройки на сайта' },
  leads: { title: 'Запитвания' },
}

const fieldLabels = Object.fromEntries(Object.values(sections).flatMap(section => section.fields || []).map(([key, label]) => [key, label]))

const imageSrc = image => image?.startsWith('/media/') ? image : `/assets/${image}`

function formatError(data) {
  if (typeof data?.detail === 'string') return data.detail
  if (data && typeof data === 'object') {
    return Object.entries(data).map(([field, value]) => `${fieldLabels[field] || field}: ${Array.isArray(value) ? value.join(', ') : value}`).join(' · ')
  }
  return 'Възникна грешка. Опитайте отново.'
}

async function jsonRequest(url, options = {}) {
  const response = await fetch(url, { credentials: 'same-origin', ...options })
  if (response.status === 204) return null
  const data = await response.json().catch(() => ({}))
  if (!response.ok) throw new Error(formatError(data))
  return data
}

function ItemSummary({ item, section }) {
  if (section === 'cars') return <><strong>{item.name}</strong><span>{item.year} · € {item.price_eur}</span></>
  if (section === 'reviews') return <><strong>{item.name}</strong><span>{item.vehicle}</span></>
  if (section === 'articles') return <><strong>{item.title}</strong><span>{item.excerpt}</span></>
  return null
}

export default function AdminApp() {
  const [csrf, setCsrf] = useState('')
  const [user, setUser] = useState(null)
  const [booting, setBooting] = useState(true)
  const [section, setSection] = useState('cars')
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(false)
  const [editing, setEditing] = useState(null)
  const [form, setForm] = useState(null)
  const [file, setFile] = useState(null)
  const [previewUrl, setPreviewUrl] = useState('')
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')

  async function refreshCsrf() {
    const data = await jsonRequest('/api/auth/csrf/')
    setCsrf(data.csrfToken)
    return data.csrfToken
  }

  useEffect(() => {
    Promise.all([refreshCsrf(), jsonRequest('/api/auth/me/')])
      .then(([, me]) => setUser(me.authenticated ? me.username : null))
      .catch(err => setError(err.message))
      .finally(() => setBooting(false))
  }, [])

  async function loadItems(nextSection = section) {
    setLoading(true); setError('')
    try {
      const data = await jsonRequest(`/api/manage/${nextSection}/`)
      if (['article-settings', 'website-settings'].includes(nextSection)) {
        setForm(data)
        setItems([])
      } else setItems(data)
    } catch (err) { setError(err.message) }
    finally { setLoading(false) }
  }

  useEffect(() => {
    if (user) loadItems(section)
  }, [user, section])

  useEffect(() => {
    if (!file) { setPreviewUrl(''); return }
    const url = URL.createObjectURL(file)
    setPreviewUrl(url)
    return () => URL.revokeObjectURL(url)
  }, [file])

  async function signIn(event) {
    event.preventDefault(); setBusy(true); setError('')
    try {
      const data = await jsonRequest('/api/auth/login/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrf },
        body: JSON.stringify({ username, password }),
      })
      await refreshCsrf()
      setPassword(''); setUser(data.username)
    } catch (err) { setError(err.message) }
    finally { setBusy(false) }
  }

  async function signOut() {
    setError('')
    try {
      await jsonRequest('/api/auth/logout/', { method: 'POST', headers: { 'X-CSRFToken': csrf } })
      await refreshCsrf()
      setUser(null); setItems([]); setEditing(null); setForm(null)
    } catch (err) { setError(err.message) }
  }

  function openEditor(item = null) {
    setEditing(item?.id ?? 'new')
    setForm(item ? { ...item } : Object.fromEntries(sections[section].fields.map(([field, , type]) => [field, type === 'checkbox' ? true : type === 'number' ? field === 'position' ? items.length : '' : type === 'optional-number' ? null : ''])))
    setFile(null); setError(''); setNotice('')
  }

  function changeField(field, value) {
    setForm(current => ({ ...current, [field]: value }))
  }

  async function save(event) {
    event.preventDefault(); setBusy(true); setError(''); setNotice('')
    try {
      const payload = { ...form }
      delete payload.id
      for (const [field, , type] of sections[section].fields) {
        if (type === 'number') payload[field] = Number(payload[field])
        if (type === 'optional-number') payload[field] = payload[field] === '' || payload[field] == null ? null : Number(payload[field])
      }
      if (file) {
        const upload = new FormData()
        upload.append('file', file)
        const result = await jsonRequest('/api/manage/upload/', { method: 'POST', headers: { 'X-CSRFToken': csrf }, body: upload })
        payload.image = result.image
      }
      await jsonRequest(`/api/manage/${section}/${editing === 'new' ? '' : `${editing}/`}`, {
        method: editing === 'new' ? 'POST' : 'PATCH',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrf },
        body: JSON.stringify(payload),
      })
      setEditing(null); setForm(null); setFile(null); setNotice('Промените са запазени.')
      await loadItems()
    } catch (err) { setError(err.message) }
    finally { setBusy(false) }
  }

  async function saveArticleSettings(event) {
    event.preventDefault(); setBusy(true); setError(''); setNotice('')
    try {
      const data = await jsonRequest('/api/manage/article-settings/', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrf },
        body: JSON.stringify({ prompt: form.prompt, interval_days: Number(form.interval_days), is_enabled: form.is_enabled }),
      })
      setForm(data); setNotice('Настройките са запазени.')
    } catch (err) { setError(err.message) }
    finally { setBusy(false) }
  }

  async function generateArticle() {
    setBusy(true); setError(''); setNotice('')
    try {
      const article = await jsonRequest('/api/manage/article-settings/generate/', {
        method: 'POST', headers: { 'X-CSRFToken': csrf },
      })
      setNotice(`Статията „${article.title}“ е създадена.`)
      await loadItems('article-settings')
    } catch (err) { setError('Статията не беше създадена. Моля, свържете се с техническия администратор.') }
    finally { setBusy(false) }
  }

  async function saveWebsiteSettings(event) {
    event.preventDefault(); setBusy(true); setError(''); setNotice('')
    try {
      const data = await jsonRequest('/api/manage/website-settings/', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrf },
        body: JSON.stringify({ phone: form.phone, email: form.email, address: form.address }),
      })
      setForm(data); setNotice('Настройките на сайта са запазени.')
    } catch (err) { setError(err.message) }
    finally { setBusy(false) }
  }

  async function remove(item) {
    if (!window.confirm(`Да изтрием ли ${sections[section].singular} „${item.name || item.title}“?`)) return
    setBusy(true); setError(''); setNotice('')
    try {
      await jsonRequest(`/api/manage/${section}/${item.id}/`, { method: 'DELETE', headers: { 'X-CSRFToken': csrf } })
      if (editing === item.id) { setEditing(null); setForm(null) }
      setNotice('Обектът е изтрит.')
      await loadItems()
    } catch (err) { setError(err.message) }
    finally { setBusy(false) }
  }

  function selectSection(key) {
    setSection(key); setEditing(null); setForm(null); setNotice(''); setError('')
  }

  return <div className="admin-app">
    {booting ? <div className="admin-loading">Зареждане…</div> : !user ? <div className="admin-login-wrap">
      <form className="admin-login" onSubmit={signIn}>
        <img src="/assets/logo.BwlAvfh8.png" alt="Pan America" />
        <h1>Администрация</h1>
        <p>Влезте с администраторския си профил.</p>
        <label>Потребителско име<input autoComplete="username" value={username} onChange={e => setUsername(e.target.value)} required /></label>
        <label>Парола<input type="password" autoComplete="current-password" value={password} onChange={e => setPassword(e.target.value)} required /></label>
        {error && <p className="admin-alert" role="alert">{error}</p>}
        <button className="admin-primary" disabled={busy || !csrf}>Вход</button>
        <a href="/">← Към сайта</a>
      </form>
    </div> : <>
      <aside className="admin-sidebar">
        <a className="admin-brand" href="/"><img src="/assets/logo.BwlAvfh8.png" alt="Pan America" /></a>
        <p className="admin-nav-label">СЪДЪРЖАНИЕ</p>
        <nav aria-label="Администрация">
          {Object.entries(sections).map(([key, config]) => <button key={key} className={section === key ? 'selected' : ''} onClick={() => selectSection(key)}>{config.title}</button>)}
        </nav>
        <div className="admin-sidebar-bottom"><a href="/">Към сайта ↗</a><button onClick={signOut}>Изход</button></div>
      </aside>
      <main className="admin-main">
        <div className="admin-topbar"><span>Pan America / Администрация</span><span>Здравейте, {user}</span></div>
        <div className="admin-content">
          <div className="admin-title-row"><div><h1>{sections[section].title}</h1><p>{section === 'article-settings' ? 'Изберете темите и графика за новите публикации.' : section === 'website-settings' ? 'Променете основните данни за контакт на сайта.' : 'Редактирайте съдържанието, което се показва на сайта.'}</p></div>{!['leads', 'article-settings', 'website-settings'].includes(section) && <button className="admin-primary" onClick={() => openEditor()}>+ Добавяне</button>}</div>
          {error && <p className="admin-alert" role="alert">{error}</p>}
          {notice && <p className="admin-success" role="status">{notice}</p>}
          {section === 'article-settings' && form && <form className="admin-editor article-settings-card" onSubmit={saveArticleSettings}>
            <div className="article-settings-intro"><h2>Съдържание и график</h2><p>Опишете какви статии искате да се публикуват на сайта.</p></div>
            <div className="article-settings-fields">
              <label>Насоки за съдържанието<textarea rows="7" value={form.prompt ?? ''} onChange={e => changeField('prompt', e.target.value)} required /><small>Например теми, стил на писане и информация, която да бъде включена.</small></label>
              <div className="article-settings-row">
                <label>Честота на публикуване<select value={form.interval_days ?? 7} onChange={e => changeField('interval_days', e.target.value)}><option value="7">Веднъж седмично</option><option value="14">На всеки две седмици</option><option value="30">Веднъж месечно</option></select></label>
                <label className="article-toggle"><input type="checkbox" checked={Boolean(form.is_enabled)} onChange={e => changeField('is_enabled', e.target.checked)} /><span aria-hidden="true"></span><div><strong>Автоматично публикуване</strong><small>{form.is_enabled ? 'Статиите се публикуват по избрания график.' : 'Автоматичното публикуване е спряно.'}</small></div></label>
              </div>
            </div>
            <div className="article-settings-actions"><button type="button" className="admin-secondary" onClick={generateArticle} disabled={busy}>{busy ? 'Създаване…' : 'Създай статия сега'}</button><button className="admin-primary" disabled={busy}>{busy ? 'Запазване…' : 'Запази'}</button></div>
          </form>}
          {section === 'website-settings' && form && <form className="admin-editor" onSubmit={saveWebsiteSettings}>
            <div className="admin-editor-head"><div><h2>Данни за контакт</h2><p>Промените се показват в горната и долната част на сайта.</p></div></div>
            <div className="admin-fields">
              <label>Телефон<input type="tel" value={form.phone ?? ''} onChange={e => changeField('phone', e.target.value)} required /></label>
              <label>Имейл<input type="email" value={form.email ?? ''} onChange={e => changeField('email', e.target.value)} required /></label>
              <label className="wide">Адрес<textarea rows="4" value={form.address ?? ''} onChange={e => changeField('address', e.target.value)} required /></label>
            </div>
            <div className="admin-editor-actions"><button className="admin-primary" disabled={busy}>{busy ? 'Запазване…' : 'Запази настройките'}</button></div>
          </form>}
          {!['article-settings', 'website-settings'].includes(section) && editing && form && <form className="admin-editor" onSubmit={save}>
            <div className="admin-editor-head"><div><h2>{editing === 'new' ? 'Нов обект' : 'Редактиране'}</h2></div><button type="button" onClick={() => { setEditing(null); setForm(null) }} aria-label="Затвори">×</button></div>
            <div className="admin-fields">{sections[section].fields.map(([field, label, type, required = true]) => <label key={field} className={`${type === 'textarea' ? 'wide' : ''} ${type === 'checkbox' ? 'check' : ''}`}>
              {type === 'checkbox' ? <><input type="checkbox" checked={Boolean(form[field])} onChange={e => changeField(field, e.target.checked)} />{label}</> : <>{label}{type === 'textarea' ? <textarea rows={field === 'description' || field === 'features' ? 8 : 5} value={form[field] ?? ''} onChange={e => changeField(field, e.target.value)} required={required} /> : type === 'image' ? <><input value={form[field] ?? ''} onChange={e => changeField(field, e.target.value)} placeholder="Име на файл или /media/uploads/..." required={!file} /><input type="file" accept="image/jpeg,image/png,image/webp" onChange={e => setFile(e.target.files?.[0] || null)} />{(previewUrl || form[field]) && <img className="admin-preview" src={previewUrl || imageSrc(form[field])} alt="Преглед" />}</> : <input type={type === 'optional-number' ? 'number' : type} min={type === 'number' || type === 'optional-number' ? 0 : undefined} value={form[field] ?? ''} onChange={e => changeField(field, e.target.value)} required={required} />}</>}
            </label>)}</div>
            <div className="admin-editor-actions"><button type="button" onClick={() => { setEditing(null); setForm(null) }}>Отказ</button><button className="admin-primary" disabled={busy}>{busy ? 'Запазване…' : 'Запази'}</button></div>
          </form>}
          {!['article-settings', 'website-settings'].includes(section) && <div className="admin-list"><div className="admin-list-header"><span>{loading ? 'Зареждане…' : `${items.length} записа`}</span><button onClick={() => loadItems()} disabled={loading}>Обнови</button></div>
            {section === 'leads' ? items.map(item => <div className="admin-row" key={item.id}><div className="admin-row-copy"><strong>{item.phone}</strong><span>{item.country} · {new Date(item.created_at).toLocaleString('bg-BG')} · {item.source === 'website' ? 'Уебсайт' : item.source}</span></div></div>) : items.map(item => <div className="admin-row" key={item.id}>
              {item.image && <img className="admin-thumb" src={imageSrc(item.image)} alt="" />}
              <div className="admin-row-copy"><ItemSummary item={item} section={section} />{section === 'articles' ? <small>{item.is_published ? 'Публикувана' : 'Скрита'} · {new Date(item.published_at).toLocaleDateString('bg-BG')}</small> : <small>{item.is_active ? 'Публикувано' : 'Скрито'} · ред {item.position}</small>}</div>
              <div className="admin-row-actions"><button onClick={() => openEditor(item)}>Редактирай</button><button className="danger" onClick={() => remove(item)} disabled={busy}>Изтрий</button></div>
            </div>)}
            {!loading && !items.length && <p className="admin-empty">Все още няма записи.</p>}
          </div>}
        </div>
      </main>
    </>}
  </div>
}
