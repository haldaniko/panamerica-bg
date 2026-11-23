"""Rebuild Bulgarian HTML fragments from the saved Pan America reference.

Requires beautifulsoup4 and ftfy in the local Python environment.
"""

from pathlib import Path
import hashlib
import json

from bs4 import BeautifulSoup, NavigableString
from ftfy import fix_text


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'frontend' / 'src' / 'reference'

TEXT = {
    'Działamy na terenie całej Polski': 'Работим на територията на цяла Полша',
    'Zadzwoń do mnie': 'Обадете ми се',
    'Główna': 'Начало',
    'O nas': 'За нас',
    'Oferty': 'Оферти',
    'Menedżerowie': 'Мениджъри',
    'Opinie': 'Отзиви',
    'Kontakt': 'Контакти',
    'Kontakt:': 'Контакти:',
    'Pomagamy': 'Помагаме ви',
    'korzystnie': 'да купите изгодно',
    'kupić samochód z USA': 'автомобил от САЩ',
    'złóż wniosek': 'Подайте заявка',
    'Samochody z': 'Автомобили от',
    'USA': 'САЩ',
    'Nasza nieskazitelna reputacja, wspierana przez grupę lojalnych klientów oraz tysiące pozytywnych komentarzy online, stawia nas na czele tej branży.': 'Безупречната ни репутация, подкрепена от лоялни клиенти и хиляди положителни отзиви онлайн, ни нарежда сред водещите компании в бранша.',
    'Jesteśmy tutaj, aby zająć się wszystkimi formalnościami w Twoim imieniu i dostarczyć wymarzony samochód z USA prosto do Twoich drzwi. Importujemy zarówno pojazdy powypadkowe, jak i nowe.': 'Ние се грижим за всички формалности вместо вас и доставяме мечтания автомобил от САЩ директно до вратата ви. Внасяме както автомобили след произшествие, така и нови.',
    'lat doświadczenia': 'години опит',
    'zadowolonych klientów': 'доволни клиенти',
    'wygranych aukcji': 'спечелени търгове',
    'korzystnie kupić': 'да купите изгодно',
    'samochód z USA': 'автомобил от САЩ',
    'Z gwarancją ceny.': 'С гарантирана цена.',
    '100% zgodności z budżetem: ani centa więcej': '100% в рамките на бюджета: нито цент повече',
    'Cena zawierająca wszystkie koszty związane z dostawą do Polski ustalana jest w umowie.': 'Цената, включваща всички разходи по доставката до Полша, се определя в договора.',
    'Oszczędność': 'Спестяване',
    'Możliwość zaoszczędzenia do 30% wartości rynkowej. Można obliczyć zysk już przed zakupem!': 'Възможност да спестите до 30% от пазарната стойност. Можете да изчислите ползата още преди покупката!',
    'Gwarancja jakości!': 'Гаранция за качество!',
    'Przed zakupem dokładnie sprawdzamy historię pojazdu za pomocą różnych narzędzi.': 'Преди покупката проверяваме подробно историята на автомобила с различни инструменти.',
    'Wsparcie 24/7': 'Подкрепа 24/7',
    'Nasi menedżerowie zapewniają pełną obsługę od zakupu po przekazanie kluczy.': 'Нашите мениджъри ви съдействат през целия процес — от покупката до предаването на ключовете.',
    'Dobór i wycena': 'Подбор и оценка',
    'kosztów samochodu': 'на разходите за автомобила',
    'Pomagamy korzystnie i z gwarancją kupić wymarzony samochód': 'Помагаме ви да купите изгодно мечтания автомобил с гаранция',
    'UZYSKAJ BEZPŁATNY DOBÓR': 'ПОЛУЧЕТЕ БЕЗПЛАТНА КОНСУЛТАЦИЯ',
    'JAK WYGLĄDA CAŁY PROCES': 'КАК ПРОТИЧА ЦЕЛИЯТ ПРОЦЕС',
    'OD WYBORU SAMOCHODU DO REJESTRACJI W POLSCE?': 'ОТ ИЗБОРА НА АВТОМОБИЛ ДО РЕГИСТРАЦИЯТА В ПОЛША?',
    'DOBÓR I WYCENA': 'ПОДБОР И ОЦЕНКА',
    'Szukamy opcji na wszystkich aukcjach (w tym zamkniętych), zgodnie z Twoimi wymaganiami i budżetem, uwzględniając wszystkie preferencje.': 'Търсим варианти на всички търгове (включително закрити) според вашите изисквания, бюджет и предпочитания.',
    'ZAKUP I UBEZPIECZENIE': 'ПОКУПКА И ЗАСТРАХОВКА',
    'Otrzymujesz dokładną kwotę wszystkich kosztów zgodnie z umową. Bez dodatkowych opłat.': 'Получавате точната сума на всички разходи според договора. Без допълнителни такси.',
    'DOSTAWA I FORMALNOŚCI': 'ДОСТАВКА И ДОКУМЕНТИ',
    'Dzięki 15-letniemu doświadczeniu nasi specjaliści szacują koszty napraw z dokładnością do 95%.': 'Благодарение на 15-годишния си опит нашите специалисти оценяват разходите за ремонт с точност до 95%.',
    'Wyślij zapytanie': 'Изпратете запитване',
    'Najlepsze Samochody': 'Най-добрите автомобили',
    'Sprawdź naszą': 'Разгледайте нашите',
    'najlepszą ofertę': 'най-добри предложения',
    'Nasi menedżerowie': 'Нашите мениджъри',
    'NAJLEPIEJ O NAS': 'НАЙ-ДОБРЕ ЗА НАС',
    'OPOWIEDZĄ KLIENCI': 'РАЗКАЗВАТ КЛИЕНТИТЕ',
    'ORAZ SETKI OPINII NA': 'И СТОТИЦИ ОТЗИВИ В',
    'GOOGLE, YOUTUBE I TELEGRAMIE': 'GOOGLE, YOUTUBE И TELEGRAM',
    'FAQs': 'ЧЗВ',
    'Często': 'Често',
    'zadawane pytania': 'задавани въпроси',
    'i odpowiedzi na nie': 'и техните отговори',
    'Tutaj znajdziesz odpowiedzi na wszystkie interesujące Cię pytania.': 'Тук ще намерите отговори на всички въпроси, които ви интересуват.',
    'Managed by Pan America': 'Поддържано от Pan America',
    'Pan America Sp. z o.o. Wszelkie prawa zastrzeżone.': 'Pan America Sp. z o.o. Всички права запазени.',
    'Polityka prywatności': 'Политика за поверителност',
    'Zobacz więcej': 'Вижте още',
    'Zalety': 'Предимства',
    'Skontaktuj się z nami': 'Свържете се с нас',
    'Wrocław, 54-203, Legnicka 59, Lokal 22B, Polska': 'Вроцлав, 54-203, ул. Легницка 59, офис 22B, Полша',
}


def translate(node):
    for text_node in list(node.find_all(string=True)):
        if not isinstance(text_node, NavigableString) or text_node.parent.name in ('script', 'style'):
            continue
        raw = str(text_node)
        key = raw.strip()
        if key in TEXT:
            text_node.replace_with(raw.replace(key, TEXT[key], 1))
    for tag in node.find_all(True):
        for attribute in ('aria-label', 'placeholder', 'title'):
            if tag.get(attribute) in TEXT:
                tag[attribute] = TEXT[tag[attribute]]


def main():
    source = BeautifulSoup((ROOT / 'Pan America.html').read_text(encoding='utf-8'), 'html.parser')
    container = source.find(id='__nuxt').select_one('.container')
    parts = {
        'header': container.find('header', recursive=False),
        'footer': container.find('footer', recursive=False),
    }
    content = container.find('div', recursive=False)
    for index, section in enumerate(content.find_all('section', recursive=False)):
        parts[section.get('id') or f'section_{index}'] = section

    page_texts = []
    translated_values = set(TEXT.values()) | {'Sofia', '11', '99%', '5600', '+48 579 774 163', 'hello@panamericaauto.pl'}
    for key, node in parts.items():
        for image in node.find_all(['img', 'source']):
            for attribute in ('src', 'srcset'):
                value = image.get(attribute, '')
                if value.startswith('./Pan America_files/'):
                    image[attribute] = '/assets/' + value.rsplit('/', 1)[-1]
                elif attribute == 'srcset':
                    image.attrs.pop(attribute, None)
            image.attrs.pop('onerror', None)
            image.attrs.pop('data-nuxt-img', None)
        for bad in node.find_all(['iframe', 'script', 'template']):
            bad.decompose()
        if key == 'header':
            for dropdown in node.select('.dropdown'):
                label = fix_text(dropdown.get_text(' ', strip=True))
                if 'Wybierz język' in label:
                    dropdown.parent.decompose()
                elif 'Wybierz biuro' in label:
                    replacement = source.new_tag('span', attrs={'class': 'office-label', 'data-v-7559b0f4': ''})
                    replacement.string = 'Sofia'
                    dropdown.replace_with(replacement)
        if key in ('bestCars', 'managers', 'feedback'):
            for item in node.select('.simple-carousel__track > .item'):
                item.decompose()
        if key == 'section_7':
            for item in node.select('.accordion .question'):
                item.decompose()
        if key == 'section_3':
            for item in node.select('.captcha'):
                item.decompose()
            selector = node.select_one('#country')
            if selector:
                selector.clear()
                for code in ('BG', 'PL', 'UA'):
                    option = source.new_tag('option', value=code)
                    option.string = code
                    if code == 'BG':
                        option['selected'] = ''
                    selector.append(option)
            for field in node.select('input[data-maska]'):
                field.attrs.pop('data-maska', None)
                field.attrs.pop('data-maska-tokens', None)
                field['placeholder'] = '+359 000 000 000'
        if key == 'section_0':
            video = node.find('video')
            video['muted'] = ''
            node.find('source')['src'] = '/assets/mainBg.Jypwl78w.mp4'
        for button in node.find_all('button'):
            if fix_text(button.get_text(' ', strip=True)).lower() in ('złóż wniosek', 'uzyskaj bezpłatny dobór', 'wyślij zapytanie'):
                button['data-lead-trigger'] = ''
        if key == 'header':
            for heading in node.select('.contacts h3, .sidebar .contact h4'):
                heading['data-lead-trigger'] = ''
        node = BeautifulSoup(fix_text(str(node)), 'html.parser')
        translate(node)
        html = str(node)
        html = html.replace('href="https://panamericaauto.pl/"', 'href="/"')
        html = html.replace('href="https://panamericaauto.pl/#', 'href="/#')
        (OUTPUT / f'{key}.html').write_text(html, encoding='utf-8')
        found = set()
        for text_node in BeautifulSoup(html, 'html.parser').stripped_strings:
            original = text_node.strip()
            if original not in translated_values or original in found:
                continue
            found.add(original)
            digest = hashlib.sha1(f'{key}:{original}'.encode('utf-8')).hexdigest()[:12]
            page_texts.append({'key': f'{key}:{digest}', 'section': key, 'source_text': original, 'value': original, 'position': len(found)})
    (ROOT / 'backend' / 'content' / 'page_text_seed.json').write_text(json.dumps(page_texts, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
