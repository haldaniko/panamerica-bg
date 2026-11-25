import React, { useEffect, useMemo, useRef, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { createPortal } from 'react-dom'
import header from './reference/header.html?raw'
import hero from './reference/section_0.html?raw'
import about from './reference/about.html?raw'
import offer from './reference/offer.html?raw'
import process from './reference/section_3.html?raw'
import carsShell from './reference/bestCars.html?raw'
import reviewsShell from './reference/feedback.html?raw'
import faqShell from './reference/section_7.html?raw'
import footer from './reference/footer.html?raw'
import faqContent from './faqContent.json'
import './reference/reference.css'
import './fonts.css'
import './site.css'
import './phone.css'
import AdminApp from './admin/Admin.jsx'
import PrivacyPolicy from './PrivacyPolicy.jsx'

const imageSrc = image => image?.startsWith('/media/') ? image : `/assets/${image}`

const defaultWebsiteSettings = {
  phone: '+48 579 774 163',
  email: 'hello@panamericaauto.pl',
  address: 'Малинова долина, ул. Еньо Вълчев 2, офис 3',
}

const legacyWebsiteAddress = 'Вроцлав, 54-203, ул. Легницка 59, офис 22B, Полша'

function applyWebsiteSettings(html, config) {
  config = config || defaultWebsiteSettings
  const replacements = new Map([
    [defaultWebsiteSettings.phone, config.phone],
    [defaultWebsiteSettings.email, config.email],
    [defaultWebsiteSettings.address, config.address],
    [legacyWebsiteAddress, config.address],
  ])
  const template = document.createElement('template')
  template.innerHTML = html
  const walker = document.createTreeWalker(template.content, NodeFilter.SHOW_TEXT)
  for (let node = walker.nextNode(); node; node = walker.nextNode()) {
    const original = node.nodeValue.trim()
    if (replacements.has(original)) node.nodeValue = node.nodeValue.replace(original, replacements.get(original))
  }
  template.content.querySelectorAll(`a[href="tel:+48579774163"]`).forEach(link => link.setAttribute('href', `tel:${config.phone.replace(/[^+\d]/g, '')}`))
  template.content.querySelectorAll(`a[href="mailto:hello@panamericaauto.pl"]`).forEach(link => link.setAttribute('href', `mailto:${config.email.trim()}`))
  template.content.querySelectorAll(`a[href="https://panamericaauto.pl/privacy-policy"]`).forEach(link => link.setAttribute('href', '/privacy-policy'))
  template.content.querySelectorAll('.map-container iframe').forEach(map => {
    const query = encodeURIComponent(`${config.address}, София, България`)
    map.setAttribute('src', `https://www.google.com/maps?q=${query}&z=16&output=embed`)
    map.setAttribute('title', `Pan America — ${config.address}`)
    const link = map.closest('a')
    if (link) {
      link.setAttribute('href', `https://www.google.com/maps/search/?api=1&query=${query}`)
      link.setAttribute('aria-label', `Отворете ${config.address} в Google Maps`)
    }
  })
  template.content.querySelectorAll('.logo').forEach(logo => {
    if (logo.parentElement?.classList.contains('site-logo-link')) return
    const link = document.createElement('a')
    link.className = 'site-logo-link'
    link.href = '/'
    link.setAttribute('aria-label', 'Към началната страница')
    logo.replaceWith(link)
    link.appendChild(logo)
  })
  template.content.querySelectorAll('footer a').forEach(link => {
    if (link.textContent.trim() !== config.address.trim()) return
    const query = encodeURIComponent(`${config.address}, София, България`)
    link.classList.add('footer-address')
    link.setAttribute('href', `https://www.google.com/maps/search/?api=1&query=${query}`)
    link.setAttribute('target', '_blank')
    link.setAttribute('rel', 'noopener noreferrer')
    link.setAttribute('aria-label', `Отворете ${config.address} в Google Maps`)
  })
  template.content.querySelectorAll('select[name="country"]').forEach(select => {
    const prefix = document.createElement('span')
    prefix.className = 'bg-phone-code'
    prefix.textContent = '+359'
    select.replaceWith(prefix)
  })
  template.content.querySelectorAll('.phone input').forEach(input => {
    input.setAttribute('placeholder', '88 123 4567')
    input.setAttribute('inputmode', 'tel')
    input.setAttribute('maxlength', '12')
    input.setAttribute('aria-label', 'Български телефонен номер')
  })
  return template.innerHTML
}

function advanceCarousel(track, direction) {
  if (!track?.children.length) return
  const cards = Array.from(track.children)
  const position = card => card.getBoundingClientRect().left - track.getBoundingClientRect().left + track.scrollLeft
  const current = cards.reduce((best, card, index) =>
    Math.abs(position(card) - track.scrollLeft) < Math.abs(position(cards[best]) - track.scrollLeft) ? index : best, 0)
  const next = cards[Math.max(0, Math.min(cards.length - 1, current + direction))]
  track.scrollTo({ left: position(next), behavior: 'smooth' })
}

function ReferenceSection({ html, section, websiteSettings }) {
  const renderedHtml = useMemo(() => applyWebsiteSettings(html, websiteSettings), [html, websiteSettings])
  const host = useRef(null)
  useEffect(() => {
    const logoLinks = Array.from(host.current?.querySelectorAll('.site-logo-link') || [])
    const handleLogoClick = event => {
      if (window.location.pathname !== '/') return
      event.preventDefault()
      window.history.replaceState(null, '', `${window.location.pathname}${window.location.search}`)
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
    logoLinks.forEach(link => link.addEventListener('click', handleLogoClick))
    return () => logoLinks.forEach(link => link.removeEventListener('click', handleLogoClick))
  }, [renderedHtml])
  useEffect(() => {
    if (section !== 'section_3') return
    const carSection = host.current?.querySelector('.process .with-car')
    const phoneInput = host.current?.querySelector('.phone input')
    if (!carSection) return
    const animate = () => carSection.classList.add('hovered')
    const keepBulgarianNumber = event => { event.target.value = nationalPhone(event.target.value) }
    carSection.addEventListener('mouseenter', animate)
    phoneInput?.addEventListener('input', keepBulgarianNumber)
    return () => {
      carSection.removeEventListener('mouseenter', animate)
      phoneInput?.removeEventListener('input', keepBulgarianNumber)
    }
  }, [renderedHtml, section])
  return <div className="reference-section" ref={host} dangerouslySetInnerHTML={{ __html: renderedHtml }} />
}

function DataSection({ html, section, children, selector = '.simple-carousel__track' }) {
  const host = useRef(null)
  const [target, setTarget] = useState(null)
  const renderedHtml = html
  const items = React.Children.toArray(children)
  useEffect(() => setTarget(host.current?.querySelector(selector)), [renderedHtml, selector])
  useEffect(() => {
    if (!target?.isConnected || section === 'section_7' || items.length < 2 || target.children.length !== items.length * 3) return
    const count = items.length
    const start = target.children[count].offsetLeft - target.children[0].offsetLeft
    const span = target.children[count * 2].offsetLeft - target.children[count].offsetLeft
    const jump = left => {
      target.style.scrollBehavior = 'auto'
      target.scrollLeft = left
      requestAnimationFrame(() => target.style.removeProperty('scroll-behavior'))
    }
    jump(start)
    let wrapTimer
    const onScroll = () => {
      clearTimeout(wrapTimer)
      wrapTimer = setTimeout(() => {
        if (target.scrollLeft >= start + span - 1) jump(target.scrollLeft - span)
        else if (target.scrollLeft <= start - span + 1) jump(target.scrollLeft + span)
      }, 120)
    }
    target.addEventListener('scroll', onScroll, { passive: true })
    let visible = false
    let paused = false
    const observer = new IntersectionObserver(([entry]) => { visible = entry.isIntersecting }, { rootMargin: '200px 0px' })
    observer.observe(target)
    const pause = () => { paused = true }
    const resume = () => { paused = false }
    target.addEventListener('touchstart', pause, { passive: true })
    target.addEventListener('touchend', resume, { passive: true })
    let drag = null
    let suppressClick = false
    const onPointerDown = event => {
      if (event.pointerType !== 'mouse' || event.button !== 0) return
      drag = { x: event.clientX, left: target.scrollLeft, moved: false, pointerId: event.pointerId }
      paused = true
    }
    const onPointerMove = event => {
      if (!drag) return
      if (!drag.moved && Math.abs(event.clientX - drag.x) > 6) {
        drag.moved = true
        target.classList.add('is-dragging')
        target.setPointerCapture(drag.pointerId)
      }
      if (!drag.moved) return
      target.scrollLeft = drag.left - (event.clientX - drag.x)
    }
    const onPointerUp = () => {
      if (!drag) return
      suppressClick = drag.moved
      if (target.hasPointerCapture(drag.pointerId)) target.releasePointerCapture(drag.pointerId)
      drag = null
      target.classList.remove('is-dragging')
      paused = false
    }
    const onClick = event => {
      if (!suppressClick) return
      event.preventDefault()
      event.stopPropagation()
      suppressClick = false
    }
    const onDragStart = event => event.preventDefault()
    target.addEventListener('pointerdown', onPointerDown)
    target.addEventListener('pointermove', onPointerMove)
    target.addEventListener('pointerup', onPointerUp)
    target.addEventListener('pointercancel', onPointerUp)
    target.addEventListener('click', onClick, true)
    target.addEventListener('dragstart', onDragStart)
    const autoplay = window.matchMedia('(prefers-reduced-motion: reduce)').matches ? null : setInterval(() => {
      if (visible && !paused) advanceCarousel(target, 1)
    }, 2000)
    return () => {
      if (autoplay) clearInterval(autoplay)
      clearTimeout(wrapTimer)
      observer.disconnect()
      target.removeEventListener('scroll', onScroll)
      target.removeEventListener('touchstart', pause)
      target.removeEventListener('touchend', resume)
      target.removeEventListener('pointerdown', onPointerDown)
      target.removeEventListener('pointermove', onPointerMove)
      target.removeEventListener('pointerup', onPointerUp)
      target.removeEventListener('pointercancel', onPointerUp)
      target.removeEventListener('click', onClick, true)
      target.removeEventListener('dragstart', onDragStart)
    }
  }, [target, items.length, section])
  useEffect(() => {
    if (section !== 'section_7') return
    const faq = host.current?.querySelector('.faq')
    const car = faq?.querySelector('.title img')
    if (!faq || !car) return
    const animate = () => car.classList.add('hovered')
    faq.addEventListener('mouseenter', animate)
    return () => faq.removeEventListener('mouseenter', animate)
  }, [renderedHtml, section])
  return <>
    <div className="reference-section" ref={host} dangerouslySetInnerHTML={{ __html: renderedHtml }} />
    {target && createPortal(section === 'section_7' || items.length < 2 ? children : [
      ...items.map((item, index) => React.cloneElement(item, { key: `before-${index}`, 'aria-hidden': 'true' })),
      ...items,
      ...items.map((item, index) => React.cloneElement(item, { key: `after-${index}`, 'aria-hidden': 'true' })),
    ], target)}
  </>
}

const carAttrs = { 'data-v-5f0b6e26': '', 'data-v-7e16871c-s': '' }
const reviewAttrs = { 'data-v-e6f3b4ef': '', 'data-v-7e16871c-s': '' }

function CarCard({ item, ...props }) {
  const isClone = props['aria-hidden'] === 'true'
  return <a className="item car-card-link" href={`/cars/${item.slug}`} tabIndex={isClone ? -1 : undefined} aria-label={`Вижте подробности за ${item.name}`} {...carAttrs} {...props}>
    <div className="additional-info" {...carAttrs}>
      <p className="year" {...carAttrs}>{item.year}</p>
      <p className="name" {...carAttrs}>{item.name}</p>
      <img src={imageSrc(item.image)} alt={item.name} width="320" loading="lazy" {...carAttrs} />
    </div>
    <p className="price" {...carAttrs}>€ {item.price_eur}</p>
  </a>
}

function ReviewCard({ item, ...props }) {
  return <div className="item" {...reviewAttrs} {...props}>
    <h3 {...reviewAttrs}>{item.name}</h3>
    <p className="car-name" {...reviewAttrs}>{item.vehicle}</p>
    <img src={imageSrc(item.image)} alt={item.vehicle} width="360" loading="lazy" {...reviewAttrs} />
    <p className="feedback-desc" {...reviewAttrs}>{item.text}</p>
    <div className="stars" {...reviewAttrs} aria-label="5/5">{[1, 2, 3, 4, 5].map(n => <svg key={n} width="24" height="24" viewBox="0 0 24 24" fill="#D01948" stroke="#D01948" {...reviewAttrs}><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>)}</div>
  </div>
}

function FaqItem({ item }) {
  const [open, setOpen] = useState(false)
  const circlePath = 'M21 11C21 16.5228 16.5228 21 11 21C5.47715 21 1 16.5228 1 11C1 5.47715 5.47715 1 11 1C16.5228 1 21 5.47715 21 11Z'
  return <article className="question" data-v-442b0cef="" data-v-fb1123f9="">
    <header data-v-fb1123f9=""><h4 className="question-title" data-v-fb1123f9="" onClick={() => setOpen(!open)} role="button" tabIndex="0" onKeyDown={e => e.key === 'Enter' && setOpen(!open)} aria-expanded={open}>{item.question}<span data-v-fb1123f9=""><svg width="22" height="22" viewBox="0 0 22 22" fill="none"><path d={`${open ? 'M7 11H15' : 'M11 7V15M7 11H15'}${circlePath}`} stroke="black" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg></span></h4></header>
    <div className={`content ${open ? 'opened' : ''}`} data-v-fb1123f9=""><p className="info" style={{ opacity: open ? 1 : 0 }} data-v-fb1123f9="">{item.answer}</p></div>
  </article>
}

function ArticlesSection({ articles }) {
  const [showMore, setShowMore] = useState(false)
  const ArticleCard = ({ article, index }) => <a className="article-card" href={`/articles/${article.slug}`}>
    <div className="article-card-meta"><span>{String(index + 1).padStart(2, '0')}</span><time dateTime={article.published_at}>{new Date(article.published_at).toLocaleDateString('bg-BG', { day: 'numeric', month: 'long', year: 'numeric' })}</time></div>
    <h3>{article.title}</h3>
    <p>{article.excerpt}</p>
  </a>
  const visibleArticles = articles.slice(0, 4)
  const additionalArticles = articles.slice(4)
  return <section className="articles-section" id="articles">
    <div className="articles-heading">
      <p>ПОЛЕЗНО ЗА АВТОМОБИЛИТЕ</p>
      <h2>Статии и съвети</h2>
      <span>Практична информация за избор, внос и поддръжка на автомобил.</span>
    </div>
    {articles.length ? <>
      <div className="articles-grid">{visibleArticles.map((article, index) => <ArticleCard article={article} index={index} key={article.id} />)}</div>
      {additionalArticles.length > 0 && <>
        <div className={`articles-more ${showMore ? 'is-open' : ''}`} aria-hidden={!showMore} inert={!showMore ? '' : undefined}><div className="articles-more-grid">{additionalArticles.map((article, index) => <ArticleCard article={article} index={index + 4} key={article.id} />)}</div></div>
        <button className="articles-more-button" type="button" aria-expanded={showMore} onClick={() => setShowMore(current => !current)}><span>{showMore ? 'Покажи по-малко' : 'Покажи още'}</span><b aria-hidden="true">{showMore ? '↑' : '↓'}</b></button>
      </>}
    </> : <p className="articles-empty">Първата ни статия ще бъде публикувана скоро.</p>}
  </section>
}

function nationalPhone(value) {
  let digits = String(value || '').replace(/\D/g, '')
  if (digits.startsWith('359')) digits = digits.slice(3)
  if (digits.startsWith('0')) digits = digits.slice(1)
  return digits.slice(0, 9)
}

function LeadModal({ onClose, initialPhone = '', source = 'website', vehicle = '' }) {
  const [phone, setPhone] = useState(() => nationalPhone(initialPhone))
  const [state, setState] = useState('idle')
  const [error, setError] = useState('')
  useEffect(() => {
    const closeOnEscape = event => event.key === 'Escape' && onClose()
    document.addEventListener('keydown', closeOnEscape)
    return () => document.removeEventListener('keydown', closeOnEscape)
  }, [onClose])
  async function submit(e) {
    e.preventDefault()
    setState('sending'); setError('')
    try {
      const national = nationalPhone(phone)
      if (national.length < 8) throw new Error('Въведете валиден български телефонен номер.')
      const response = await fetch('/api/leads/', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: `+359${national}`, source }) })
      if (!response.ok) throw new Error('Проверете телефонния номер и опитайте отново.')
      setState('sent')
    } catch (err) { setError(err.message); setState('idle') }
  }
  return <div className="lead-overlay" onMouseDown={e => e.target === e.currentTarget && onClose()}>
    <div className="lead-modal" role="dialog" aria-modal="true" aria-labelledby="lead-title">
      <button className="lead-close" aria-label="Затвори" onClick={onClose}>×</button>
      {state === 'sent' ? <><h2 id="lead-title">Благодарим!</h2><p>Скоро ще се свържем с вас.</p></> : <><h2 id="lead-title">{vehicle ? `Запитване за ${vehicle}` : 'Да ви се обадим'}</h2><p>Оставете български телефонен номер и наш специалист ще се свърже с вас.</p><form onSubmit={submit}><div className="lead-fields"><span className="phone-prefix">+359</span><input type="tel" inputMode="tel" aria-label="Български телефонен номер" placeholder="88 123 4567" minLength="8" maxLength="12" required value={phone} onChange={e => setPhone(nationalPhone(e.target.value))} /></div>{error && <p className="lead-error" role="alert">{error}</p>}<button type="submit" disabled={state === 'sending'}>{state === 'sending' ? 'Изпращане…' : 'Изпратете запитване'}</button></form></>}
    </div>
  </div>
}

function App() {
  const [data, setData] = useState({ cars: [], reviews: [], articles: [], websiteSettings: null })
  const [modal, setModal] = useState(null)
  const [loadError, setLoadError] = useState(false)
  useEffect(() => {
    Promise.allSettled([['cars', 'cars'], ['reviews', 'reviews'], ['articles', 'articles'], ['websiteSettings', 'website-settings']].map(async ([key, path]) => {
      const response = await fetch(`/api/${path}/`)
      if (!response.ok) throw new Error(key)
      return [key, await response.json()]
    })).then(results => {
      setData(current => ({ ...current, ...Object.fromEntries(results.filter(result => result.status === 'fulfilled').map(result => result.value)) }))
      if (results.some(result => result.status === 'rejected')) setLoadError(true)
    })
  }, [])
  useEffect(() => {
    function onClick(e) {
      const button = e.target.closest('button')
      if (button?.closest('.lead-modal')) return
      const navButton = e.target.closest('.navigation .navBtn')
      if (navButton) {
        const track = navButton.closest('.slider')?.querySelector('.simple-carousel__track')
        advanceCarousel(track, navButton.classList.contains('next') ? 1 : -1)
        return
      }
      if (e.target.closest('.mobile-menu')) {
        document.querySelector('header .sidebar')?.classList.toggle('open'); return
      }
      if (e.target.closest('.sidebar.open') && (e.target.tagName === 'A' || e.target.classList.contains('sidebar'))) {
        document.querySelector('header .sidebar')?.classList.remove('open')
      }
      if (e.target.closest('[data-lead-trigger]')) {
        e.preventDefault(); setModal({ phone: button?.closest('.panel')?.querySelector('input')?.value || '' })
      }
    }
    document.addEventListener('click', onClick)
    return () => document.removeEventListener('click', onClick)
  }, [])
  useEffect(() => {
    const onKey = e => {
      const navButton = e.target.closest?.('.navigation .navBtn')
      if (navButton && (e.key === 'Enter' || e.key === ' ')) {
        e.preventDefault()
        navButton.click()
      }
      if (e.key === 'Escape') setModal(null)
    }
    document.addEventListener('keydown', onKey)
    return () => document.removeEventListener('keydown', onKey)
  }, [])
  return <div className="container" data-v-23ebea15="">
    <ReferenceSection html={header} section="header" websiteSettings={data.websiteSettings} />
    <main>
      <ReferenceSection html={hero} section="section_0" />
      <ReferenceSection html={about} section="about" />
      <ReferenceSection html={offer} section="offer" />
      <ReferenceSection html={process} section="section_3" />
      {loadError && <p className="api-error" role="alert">Не успяхме да заредим съдържанието. Обновете страницата.</p>}
      <DataSection html={carsShell} section="bestCars">{data.cars.map(item => <CarCard key={item.id} item={item} />)}</DataSection>
      <DataSection html={reviewsShell} section="feedback">{data.reviews.map(item => <ReviewCard key={item.id} item={item} />)}</DataSection>
      <ArticlesSection articles={data.articles} />
      <DataSection html={faqShell} section="section_7" selector=".accordion">{faqContent.map(item => <FaqItem key={item.id} item={item} />)}</DataSection>
    </main>
    <ReferenceSection html={footer} section="footer" websiteSettings={data.websiteSettings} />
    {modal && <LeadModal initialPhone={modal.phone} onClose={() => setModal(null)} />}
  </div>
}

function PrivacyPolicyPage() {
  const [websiteSettings, setWebsiteSettings] = useState(null)
  useEffect(() => {
    fetch('/api/website-settings/').then(response => response.ok ? response.json() : Promise.reject()).then(setWebsiteSettings).catch(() => {})
  }, [])
  useEffect(() => {
    const previous = document.title
    document.title = 'Политика за поверителност | Pan America'
    return () => { document.title = previous }
  }, [])
  return <div className="container" data-v-23ebea15="">
    <ReferenceSection html={header} section="header" websiteSettings={websiteSettings} />
    <PrivacyPolicy websiteSettings={websiteSettings} />
    <ReferenceSection html={footer} section="footer" websiteSettings={websiteSettings} />
  </div>
}

function ArticlePage({ slug }) {
  const [article, setArticle] = useState(null)
  const [websiteSettings, setWebsiteSettings] = useState(null)
  const [notFound, setNotFound] = useState(false)
  useEffect(() => {
    Promise.allSettled([
      fetch(`/api/articles/${encodeURIComponent(slug)}/`).then(response => {
        if (!response.ok) throw new Error('not-found')
        return response.json()
      }),
      fetch('/api/website-settings/').then(response => response.ok ? response.json() : null),
    ]).then(([articleResult, settingsResult]) => {
      if (articleResult.status === 'fulfilled') setArticle(articleResult.value)
      else setNotFound(true)
      if (settingsResult.status === 'fulfilled') setWebsiteSettings(settingsResult.value)
    })
  }, [slug])
  useEffect(() => {
    if (!article) return
    document.title = `${article.title} | Pan America`
  }, [article])
  const blocks = article?.content.split(/\n\s*\n/).filter(Boolean) || []
  return <div className="container" data-v-23ebea15="">
    <ReferenceSection html={header} section="header" websiteSettings={websiteSettings} />
    <main className="article-page">
      {notFound ? <div className="article-not-found"><p>404</p><h1>Статията не е намерена</h1><a href="/#articles">Към всички статии</a></div> : article ? <article>
        <a className="article-back" href="/#articles">← Всички статии</a>
        <header>
          <time dateTime={article.published_at}>{new Date(article.published_at).toLocaleDateString('bg-BG', { day: 'numeric', month: 'long', year: 'numeric' })}</time>
          <h1>{article.title}</h1>
          <p>{article.excerpt}</p>
        </header>
        <div className="article-page-content">{blocks.map((block, index) => {
          const isHeading = block.length < 80 && !/[.!?]$/.test(block)
          return isHeading ? <h2 key={index}>{block}</h2> : <p key={index}>{block}</p>
        })}</div>
      </article> : <div className="article-loading">Зареждане…</div>}
    </main>
    <ReferenceSection html={footer} section="footer" websiteSettings={websiteSettings} />
  </div>
}

function CarPage({ slug }) {
  const [car, setCar] = useState(null)
  const [websiteSettings, setWebsiteSettings] = useState(null)
  const [notFound, setNotFound] = useState(false)
  const [showLeadModal, setShowLeadModal] = useState(false)
  useEffect(() => {
    Promise.allSettled([
      fetch(`/api/cars/${encodeURIComponent(slug)}/`).then(response => {
        if (!response.ok) throw new Error('not-found')
        return response.json()
      }),
      fetch('/api/website-settings/').then(response => response.ok ? response.json() : null),
    ]).then(([carResult, settingsResult]) => {
      if (carResult.status === 'fulfilled') setCar(carResult.value)
      else setNotFound(true)
      if (settingsResult.status === 'fulfilled') setWebsiteSettings(settingsResult.value)
    })
  }, [slug])
  useEffect(() => {
    if (car) document.title = `${car.name} | Pan America`
  }, [car])
  const specs = car ? [
    ['Година', car.year],
    ['Пробег', car.mileage_km != null ? `${car.mileage_km.toLocaleString('bg-BG')} км` : null],
    ['Двигател', car.engine],
    ['Мощност', car.power_hp != null ? `${car.power_hp} к.с.` : null],
    ['Гориво', car.fuel],
    ['Скоростна кутия', car.transmission],
    ['Задвижване', car.drivetrain],
    ['Купе', car.body_type],
    ['Цвят', car.color],
    ['Състояние', car.condition],
    ['VIN', car.vin],
    ['Местоположение', car.location],
  ].filter(([, value]) => value !== null && value !== '') : []
  const features = car?.features.split(/\r?\n|,/).map(item => item.trim()).filter(Boolean) || []
  const description = car?.description.split(/\n\s*\n/).map(item => item.trim()).filter(Boolean) || []
  return <div className="container" data-v-23ebea15="">
    <ReferenceSection html={header} section="header" websiteSettings={websiteSettings} />
    <main className="car-page">
      {notFound ? <div className="car-not-found"><p>404</p><h1>Автомобилът не е намерен</h1><a href="/#bestCars">Към автомобилите</a></div> : car ? <article>
        <a className="car-back" href="/#bestCars">← Всички автомобили</a>
        <div className="car-detail-hero">
          <div className="car-detail-image"><img src={imageSrc(car.image)} alt={car.name} /></div>
          <div className="car-detail-intro">
            <p className="car-detail-year">{car.year}</p>
            <h1>{car.name}</h1>
            {car.summary && <p className="car-detail-summary">{car.summary}</p>}
            <p className="car-detail-price">€ {car.price_eur.toLocaleString('bg-BG')}</p>
            <div className="car-detail-actions">
              <button className="car-detail-secondary" type="button" onClick={() => setShowLeadModal(true)}>Изпратете запитване</button>
            </div>
          </div>
        </div>
        {specs.length > 0 && <section className="car-detail-section"><p className="car-detail-eyebrow">ХАРАКТЕРИСТИКИ</p><h2>Данни за автомобила</h2><dl className="car-specs">{specs.map(([label, value]) => <div key={label}><dt>{label}</dt><dd>{value}</dd></div>)}</dl></section>}
        {description.length > 0 && <section className="car-detail-section car-description"><p className="car-detail-eyebrow">ПОВЕЧЕ ИНФОРМАЦИЯ</p><h2>Описание</h2>{description.map((paragraph, index) => <p key={index}>{paragraph}</p>)}</section>}
        {features.length > 0 && <section className="car-detail-section"><p className="car-detail-eyebrow">ОБОРУДВАНЕ</p><h2>Основни екстри</h2><ul className="car-features">{features.map((feature, index) => <li key={`${feature}-${index}`}>{feature}</li>)}</ul></section>}
      </article> : <div className="article-loading">Зареждане…</div>}
    </main>
    <ReferenceSection html={footer} section="footer" websiteSettings={websiteSettings} />
    {showLeadModal && car && <LeadModal source={`car:${car.slug}`} vehicle={car.name} onClose={() => setShowLeadModal(false)} />}
  </div>
}

const path = window.location.pathname.replace(/\/+$/, '') || '/'
const articleMatch = path.match(/^\/articles\/([^/]+)$/)
const carMatch = path.match(/^\/cars\/([^/]+)$/)
createRoot(document.getElementById('root')).render(path.startsWith('/admin') ? <AdminApp /> : path === '/privacy-policy' ? <PrivacyPolicyPage /> : articleMatch ? <ArticlePage slug={decodeURIComponent(articleMatch[1])} /> : carMatch ? <CarPage slug={decodeURIComponent(carMatch[1])} /> : <App />)
