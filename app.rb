# frozen_string_literal: true

require 'rack'
require 'json'
require 'securerandom'
require 'base64'

TRANSLATIONS = {
  'en' => {
    html_lang: 'en',
    nav_about: 'About', nav_features: 'Features', nav_contact: 'Contact',
    badge: 'Powered by Artificial Intelligence',
    hero_title_gradient: 'AutoBot AI workflow', hero_title_rest: 'is near',
    hero_sub: 'The future of digital product development is here. Build faster, smarter, and more reliably by putting AI at the heart of your workflow.',
    hero_cta: 'Discover how ↓',
    about_label: 'About',
    about_title: 'AI is reshaping how digital products are built',
    about_p1: "Today, artificial intelligence isn't just a tool — it's a co-creator. From generating code and content to automating repetitive tasks and surfacing insights, AI enables teams to ship digital products at a pace and quality that was simply not possible before.",
    about_p2: "Whether you're designing a mobile app, a web platform, or a complex backend system, integrating AI into your workflow reduces friction, accelerates iteration, and helps you focus on what matters most: delivering value to your users.",
    stat1_label: 'Faster prototype-to-production cycles',
    stat2_label: 'Reduction in repetitive engineering tasks',
    stat3_label: 'AI-assisted code review &amp; testing',
    features_label: 'Key Points',
    features_title: 'Why AI belongs in your product workflow',
    features_desc: 'These are the capabilities that make AI an indispensable partner for any modern digital team.',
    card1_title: 'Accelerated Development',
    card1_desc: 'AI-assisted coding, scaffolding, and boilerplate generation cut time-to-first-commit dramatically so your team ships features faster.',
    card2_title: 'Intelligent Code Review',
    card2_desc: 'Automated analysis catches bugs, security vulnerabilities, and style issues before they reach production — at any hour of the day.',
    card3_title: 'Continuous Iteration',
    card3_desc: "AI learns from your feedback loops, making every subsequent release smarter and more aligned with your users' real needs.",
    card4_title: 'Built-in Quality',
    card4_desc: 'Generate tests, documentation, and observability instrumentation alongside your code — quality baked in, not bolted on.',
    card5_title: 'Data-Driven Decisions',
    card5_desc: 'AI surfaces patterns in usage data and error reports so product and engineering teams can prioritize with confidence.',
    card6_title: 'Human + AI Collaboration',
    card6_desc: 'AI handles the mechanical; humans handle the creative. Together, you build products with more empathy and fewer defects.',
    contact_label: 'Contact', contact_title: 'Get in touch',
    contact_company_label: 'Company', contact_address_label: 'Address',
    contact_enquiries_label: 'General Enquiries', contact_support_label: 'Support',
    contact_phone_label: 'Phone', contact_website_label: 'Website',
    contact_hours_label: 'Business Hours',
    contact_hours_value: 'Monday–Friday, 9:00 AM – 6:00 PM PST',
    form_name_label: 'Name', form_name_placeholder: 'Your name',
    form_email_label: 'Email', form_email_placeholder: 'you@example.com',
    form_message_label: 'Message', form_message_placeholder: 'How can we help?',
    form_submit: 'Send message →',
    footer_rights: 'All rights reserved.',
  },
  'pl' => {
    html_lang: 'pl',
    nav_about: 'O nas', nav_features: 'Funkcje', nav_contact: 'Kontakt',
    badge: 'Napędzane przez Sztuczną Inteligencję',
    hero_title_gradient: 'Workflow AI AutoBot', hero_title_rest: 'jest blisko',
    hero_sub: 'Przyszłość tworzenia produktów cyfrowych jest tutaj. Buduj szybciej, mądrzej i bardziej niezawodnie, stawiając AI w centrum swojego workflow.',
    hero_cta: 'Odkryj jak ↓',
    about_label: 'O nas',
    about_title: 'AI zmienia sposób tworzenia produktów cyfrowych',
    about_p1: 'Dziś sztuczna inteligencja to nie tylko narzędzie — to współtwórca. Od generowania kodu i treści po automatyzację powtarzalnych zadań, AI umożliwia zespołom dostarczanie produktów cyfrowych w tempie i jakości, która wcześniej była po prostu niemożliwa.',
    about_p2: 'Niezależnie od tego, czy projektujesz aplikację mobilną, platformę internetową czy złożony system backendowy, integracja AI w Twoim workflow zmniejsza tarcie, przyspiesza iterację i pomaga skupić się na tym, co najważniejsze: dostarczaniu wartości użytkownikom.',
    stat1_label: 'Szybsze cykle od prototypu do produkcji',
    stat2_label: 'Redukcja powtarzalnych zadań inżynierskich',
    stat3_label: 'Przegląd kodu i testy wspomagane przez AI',
    features_label: 'Kluczowe punkty',
    features_title: 'Dlaczego AI należy do Twojego workflow produktowego',
    features_desc: 'To możliwości, które sprawiają, że AI jest niezastąpionym partnerem dla każdego nowoczesnego zespołu cyfrowego.',
    card1_title: 'Przyspieszone tworzenie',
    card1_desc: 'Wspomagane przez AI kodowanie, scaffolding i generowanie szablonów drastycznie skracają czas do pierwszego commita, dzięki czemu zespół dostarcza funkcje szybciej.',
    card2_title: 'Inteligentny przegląd kodu',
    card2_desc: 'Automatyczna analiza wychwytuje błędy, luki bezpieczeństwa i problemy ze stylem zanim trafią na produkcję — o każdej porze dnia.',
    card3_title: 'Ciągła iteracja',
    card3_desc: 'AI uczy się z Twoich pętli zwrotnych, sprawiając, że każde kolejne wydanie jest mądrzejsze i lepiej odpowiada realnym potrzebom użytkowników.',
    card4_title: 'Wbudowana jakość',
    card4_desc: 'Generuj testy, dokumentację i instrumentację obserwowalności razem z kodem — jakość wbudowana, nie doklejana.',
    card5_title: 'Decyzje oparte na danych',
    card5_desc: 'AI wydobywa wzorce z danych użytkowania i raportów błędów, dzięki czemu zespoły mogą ustalać priorytety z pewnością.',
    card6_title: 'Współpraca człowiek + AI',
    card6_desc: 'AI zajmuje się mechanicznym, ludzie kreatywnym. Razem tworzycie produkty z większą empatią i mniejszą liczbą defektów.',
    contact_label: 'Kontakt', contact_title: 'Skontaktuj się',
    contact_company_label: 'Firma', contact_address_label: 'Adres',
    contact_enquiries_label: 'Ogólne zapytania', contact_support_label: 'Wsparcie',
    contact_phone_label: 'Telefon', contact_website_label: 'Strona internetowa',
    contact_hours_label: 'Godziny pracy',
    contact_hours_value: 'Poniedziałek–Piątek, 9:00 – 18:00 PST',
    form_name_label: 'Imię', form_name_placeholder: 'Twoje imię',
    form_email_label: 'Email', form_email_placeholder: 'ty@przyklad.com',
    form_message_label: 'Wiadomość', form_message_placeholder: 'Jak możemy pomóc?',
    form_submit: 'Wyślij wiadomość →',
    footer_rights: 'Wszelkie prawa zastrzeżone.',
  },
  'de' => {
    html_lang: 'de',
    nav_about: 'Über uns', nav_features: 'Funktionen', nav_contact: 'Kontakt',
    badge: 'Angetrieben durch Künstliche Intelligenz',
    hero_title_gradient: 'AutoBot KI-Workflow', hero_title_rest: 'ist nah',
    hero_sub: 'Die Zukunft der digitalen Produktentwicklung ist hier. Bauen Sie schneller, intelligenter und zuverlässiger, indem Sie KI in den Mittelpunkt Ihres Workflows stellen.',
    hero_cta: 'Entdecken Sie wie ↓',
    about_label: 'Über uns',
    about_title: 'KI verändert die Art, wie digitale Produkte entwickelt werden',
    about_p1: 'Heute ist künstliche Intelligenz nicht nur ein Werkzeug — sie ist ein Mitschöpfer. Vom Generieren von Code und Inhalten bis zur Automatisierung repetitiver Aufgaben ermöglicht KI Teams, digitale Produkte in einem Tempo und einer Qualität zu liefern, die zuvor schlicht nicht möglich war.',
    about_p2: 'Ob Sie eine mobile App, eine Webplattform oder ein komplexes Backend-System entwickeln — die Integration von KI in Ihren Workflow reduziert Reibung, beschleunigt Iterationen und hilft Ihnen, sich auf das Wesentliche zu konzentrieren: Mehrwert für Ihre Nutzer zu schaffen.',
    stat1_label: 'Schnellere Prototyp-zu-Produktions-Zyklen',
    stat2_label: 'Reduzierung repetitiver Engineering-Aufgaben',
    stat3_label: 'KI-gestütztes Code-Review &amp; Testing',
    features_label: 'Kernpunkte',
    features_title: 'Warum KI in Ihren Produkt-Workflow gehört',
    features_desc: 'Das sind die Fähigkeiten, die KI zu einem unverzichtbaren Partner für jedes moderne digitale Team machen.',
    card1_title: 'Beschleunigte Entwicklung',
    card1_desc: 'KI-gestütztes Coding, Scaffolding und Boilerplate-Generierung verkürzen die Zeit bis zum ersten Commit drastisch, sodass Ihr Team Funktionen schneller liefert.',
    card2_title: 'Intelligentes Code-Review',
    card2_desc: 'Automatisierte Analysen erkennen Fehler, Sicherheitslücken und Stilprobleme bevor sie die Produktion erreichen — zu jeder Tages- und Nachtzeit.',
    card3_title: 'Kontinuierliche Iteration',
    card3_desc: 'KI lernt aus Ihren Feedback-Schleifen und macht jedes nachfolgende Release intelligenter und besser auf die echten Bedürfnisse Ihrer Nutzer abgestimmt.',
    card4_title: 'Eingebaute Qualität',
    card4_desc: 'Generieren Sie Tests, Dokumentation und Observability-Instrumentierung neben Ihrem Code — Qualität eingebaut, nicht nachträglich hinzugefügt.',
    card5_title: 'Datenbasierte Entscheidungen',
    card5_desc: 'KI erkennt Muster in Nutzungsdaten und Fehlerberichten, sodass Teams mit Zuversicht priorisieren können.',
    card6_title: 'Mensch + KI Zusammenarbeit',
    card6_desc: 'KI übernimmt das Mechanische, Menschen das Kreative. Gemeinsam bauen Sie Produkte mit mehr Empathie und weniger Defekten.',
    contact_label: 'Kontakt', contact_title: 'Kontakt aufnehmen',
    contact_company_label: 'Unternehmen', contact_address_label: 'Adresse',
    contact_enquiries_label: 'Allgemeine Anfragen', contact_support_label: 'Support',
    contact_phone_label: 'Telefon', contact_website_label: 'Webseite',
    contact_hours_label: 'Geschäftszeiten',
    contact_hours_value: 'Montag–Freitag, 9:00 – 18:00 Uhr PST',
    form_name_label: 'Name', form_name_placeholder: 'Ihr Name',
    form_email_label: 'E-Mail', form_email_placeholder: 'sie@beispiel.de',
    form_message_label: 'Nachricht', form_message_placeholder: 'Wie können wir helfen?',
    form_submit: 'Nachricht senden →',
    footer_rights: 'Alle Rechte vorbehalten.',
  },
  'fr' => {
    html_lang: 'fr',
    nav_about: 'À propos', nav_features: 'Fonctionnalités', nav_contact: 'Contact',
    badge: "Propulsé par l'Intelligence Artificielle",
    hero_title_gradient: 'Le workflow IA AutoBot', hero_title_rest: 'est proche',
    hero_sub: "L'avenir du développement de produits numériques est ici. Construisez plus vite, plus intelligemment et plus fiablement en plaçant l'IA au cœur de votre workflow.",
    hero_cta: 'Découvrir comment ↓',
    about_label: 'À propos',
    about_title: "L'IA redéfinit la façon dont les produits numériques sont créés",
    about_p1: "Aujourd'hui, l'intelligence artificielle n'est pas seulement un outil — c'est un co-créateur. De la génération de code et de contenu à l'automatisation des tâches répétitives, l'IA permet aux équipes de livrer des produits numériques à un rythme et une qualité qui n'était tout simplement pas possible auparavant.",
    about_p2: "Que vous conceviez une application mobile, une plateforme web ou un système backend complexe, intégrer l'IA dans votre workflow réduit les frictions, accélère les itérations et vous aide à vous concentrer sur ce qui compte le plus : apporter de la valeur à vos utilisateurs.",
    stat1_label: 'Cycles prototype-vers-production plus rapides',
    stat2_label: "Réduction des tâches d'ingénierie répétitives",
    stat3_label: 'Revue de code &amp; tests assistés par IA',
    features_label: 'Points clés',
    features_title: "Pourquoi l'IA appartient à votre workflow produit",
    features_desc: "Ce sont les capacités qui font de l'IA un partenaire indispensable pour toute équipe numérique moderne.",
    card1_title: 'Développement accéléré',
    card1_desc: "Le codage, le scaffolding et la génération de boilerplate assistés par IA réduisent considérablement le temps jusqu'au premier commit, permettant à votre équipe de livrer des fonctionnalités plus rapidement.",
    card2_title: 'Revue de code intelligente',
    card2_desc: "L'analyse automatisée détecte les bugs, les vulnérabilités de sécurité et les problèmes de style avant qu'ils n'atteignent la production — à toute heure du jour.",
    card3_title: 'Itération continue',
    card3_desc: "L'IA apprend de vos boucles de rétroaction, rendant chaque nouvelle version plus intelligente et mieux alignée sur les besoins réels de vos utilisateurs.",
    card4_title: 'Qualité intégrée',
    card4_desc: "Générez des tests, de la documentation et une instrumentation d'observabilité aux côtés de votre code — la qualité intégrée, pas rajoutée.",
    card5_title: 'Décisions basées sur les données',
    card5_desc: "L'IA fait ressortir les patterns dans les données d'utilisation et les rapports d'erreurs, permettant aux équipes de prioriser en toute confiance.",
    card6_title: 'Collaboration Humain + IA',
    card6_desc: "L'IA gère le mécanique, les humains le créatif. Ensemble, vous construisez des produits avec plus d'empathie et moins de défauts.",
    contact_label: 'Contact', contact_title: 'Prendre contact',
    contact_company_label: 'Entreprise', contact_address_label: 'Adresse',
    contact_enquiries_label: 'Renseignements généraux', contact_support_label: 'Support',
    contact_phone_label: 'Téléphone', contact_website_label: 'Site web',
    contact_hours_label: "Heures d'ouverture",
    contact_hours_value: 'Lundi–Vendredi, 9h00 – 18h00 PST',
    form_name_label: 'Nom', form_name_placeholder: 'Votre nom',
    form_email_label: 'Email', form_email_placeholder: 'vous@exemple.fr',
    form_message_label: 'Message', form_message_placeholder: 'Comment pouvons-nous vous aider ?',
    form_submit: 'Envoyer le message →',
    footer_rights: 'Tous droits réservés.',
  },
}.freeze

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/'
      [200, { 'content-type' => 'application/json' }, [{ message: 'Welcome' }.to_json]]
    elsif request.path == '/up'
      [200, { 'content-type' => 'application/json' }, [{ message: "I'm wokring" }.to_json]]
    elsif request.path == '/info'
      [200, { 'content-type' => 'application/json' }, [{ app: 'Test', date: Time.now.strftime('%Y-%m-%d'), ruby_version: RUBY_VERSION, user_agent: request.user_agent, ip: request.ip }.to_json]]
    elsif request.path == '/about'
      lang = TRANSLATIONS.key?(request.params['lang']) ? request.params['lang'] : 'en'
      [200, { 'content-type' => 'text/html' }, [about_html(lang)]]
    elsif request.path == '/gen'
      token = SecureRandom.hex(16)
      prefix = request.params['prefix']
      postfix = request.params['postfix']
      token = "#{prefix}_#{token}" if prefix
      token = "#{token}_#{postfix}" if postfix
      [200, { 'content-type' => 'application/json' }, [{ token: token }.to_json]]
    elsif request.path == '/b64' && request.post?
      body = request.params['body'].to_s
      encoded = Base64.strict_encode64(body)
      [200, { 'content-type' => 'application/json' }, [{ result: encoded }.to_json]]
    else
      [404, { 'content-type' => 'application/json' }, [{ error: 'Not Found' }.to_json]]
    end
  end

  private

  def about_html(lang = 'en')
    t = TRANSLATIONS[lang]
    <<~HTML
      <!DOCTYPE html>
      <html lang="#{t[:html_lang]}">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>AutoBot — AI Workflow is Near</title>
        <style>
          *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

          :root {
            --bg: #0a0a0f;
            --surface: #12121a;
            --surface2: #1a1a26;
            --border: rgba(120, 80, 255, 0.2);
            --accent: #7850ff;
            --accent2: #00d4ff;
            --text: #e8e8f0;
            --muted: #8888aa;
            --radius: 16px;
            --nav-bg: rgba(10, 10, 15, 0.8);
          }

          [data-theme="light"] {
            --bg: #f5f5fa;
            --surface: #ffffff;
            --surface2: #ebebf5;
            --border: rgba(96, 64, 238, 0.2);
            --accent: #6040ee;
            --accent2: #0099cc;
            --text: #1a1a2e;
            --muted: #555577;
            --nav-bg: rgba(245, 245, 250, 0.85);
          }

          html { scroll-behavior: smooth; }

          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
            min-height: 100vh;
          }

          /* ── Nav ── */
          nav {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 2rem;
            backdrop-filter: blur(12px);
            background: var(--nav-bg);
            border-bottom: 1px solid var(--border);
          }
          .nav-logo {
            font-size: 1.25rem;
            font-weight: 700;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }
          .nav-links { display: flex; gap: 2rem; list-style: none; }
          .nav-links a { color: var(--muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
          .nav-links a:hover { color: var(--text); }

          /* ── Hero ── */
          .hero {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 6rem 2rem 4rem;
            position: relative;
            overflow: hidden;
          }

          /* animated mesh gradient background */
          .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
              radial-gradient(ellipse 80% 60% at 20% 40%, rgba(120, 80, 255, 0.18) 0%, transparent 60%),
              radial-gradient(ellipse 60% 50% at 80% 60%, rgba(0, 212, 255, 0.14) 0%, transparent 55%),
              radial-gradient(ellipse 50% 40% at 50% 10%, rgba(120, 80, 255, 0.1) 0%, transparent 50%);
            animation: drift 10s ease-in-out infinite alternate;
          }
          @keyframes drift {
            from { transform: scale(1) translateY(0); }
            to   { transform: scale(1.05) translateY(-20px); }
          }

          /* floating orbs */
          .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.35;
            animation: float 8s ease-in-out infinite alternate;
          }
          .orb-1 { width: 400px; height: 400px; background: var(--accent); top: -80px; left: -100px; animation-delay: 0s; }
          .orb-2 { width: 300px; height: 300px; background: var(--accent2); bottom: 0; right: -60px; animation-delay: 3s; }
          .orb-3 { width: 200px; height: 200px; background: #ff5090; top: 40%; left: 60%; animation-delay: 6s; }
          @keyframes float {
            from { transform: translate(0, 0) scale(1); }
            to   { transform: translate(20px, -30px) scale(1.1); }
          }

          .hero-content { position: relative; z-index: 1; max-width: 800px; }

          .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.4rem 1rem;
            border-radius: 100px;
            border: 1px solid var(--border);
            background: rgba(120, 80, 255, 0.1);
            font-size: 0.8rem;
            color: var(--accent2);
            margin-bottom: 1.5rem;
            letter-spacing: 0.05em;
          }
          .badge::before { content: '●'; font-size: 0.6rem; animation: pulse 2s ease infinite; }
          @keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.3; } }

          h1 {
            font-size: clamp(2.5rem, 7vw, 5rem);
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.03em;
            margin-bottom: 1.5rem;
          }
          h1 .gradient {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent2) 50%, #ff5090 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }

          .hero-sub {
            font-size: 1.15rem;
            color: var(--muted);
            max-width: 600px;
            margin: 0 auto 2.5rem;
          }

          .hero-cta {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.85rem 2rem;
            border-radius: 100px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff;
            font-weight: 600;
            text-decoration: none;
            font-size: 1rem;
            transition: opacity 0.2s, transform 0.2s;
          }
          .hero-cta:hover { opacity: 0.9; transform: translateY(-2px); }

          /* ── Sections ── */
          section { padding: 5rem 2rem; max-width: 1100px; margin: 0 auto; }

          .section-label {
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 0.75rem;
          }
          .section-title {
            font-size: clamp(1.8rem, 4vw, 2.8rem);
            font-weight: 700;
            letter-spacing: -0.02em;
            margin-bottom: 1rem;
          }
          .section-desc { color: var(--muted); max-width: 620px; font-size: 1.05rem; margin-bottom: 3rem; }

          /* ── About text ── */
          .about-text {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
          }
          .about-text p { color: var(--muted); line-height: 1.8; }
          .about-text p + p { margin-top: 1rem; }
          .about-visual {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
          }
          .stat { display: flex; flex-direction: column; }
          .stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }
          .stat-label { font-size: 0.85rem; color: var(--muted); }
          .stat-divider { height: 1px; background: var(--border); }

          /* ── Cards ── */
          .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.5rem;
          }
          .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.75rem;
            transition: border-color 0.25s, transform 0.25s;
          }
          .card:hover { border-color: var(--accent); transform: translateY(-4px); }
          .card-icon {
            width: 48px; height: 48px;
            border-radius: 12px;
            background: rgba(120, 80, 255, 0.15);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
          }
          .card h3 { font-size: 1.05rem; font-weight: 700; margin-bottom: 0.5rem; }
          .card p { font-size: 0.9rem; color: var(--muted); line-height: 1.7; }

          /* ── Contact ── */
          .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: start;
          }
          .contact-info { display: flex; flex-direction: column; gap: 1.25rem; }
          .contact-item { display: flex; flex-direction: column; gap: 0.2rem; }
          .contact-item strong { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--accent); }
          .contact-item span, .contact-item a { color: var(--muted); font-size: 0.95rem; text-decoration: none; }
          .contact-item a:hover { color: var(--text); }

          form { display: flex; flex-direction: column; gap: 1rem; }
          .field { display: flex; flex-direction: column; gap: 0.4rem; }
          label { font-size: 0.85rem; color: var(--muted); }
          input, textarea {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            color: var(--text);
            font-size: 0.95rem;
            font-family: inherit;
            transition: border-color 0.2s;
            outline: none;
          }
          input:focus, textarea:focus { border-color: var(--accent); }
          textarea { resize: vertical; min-height: 120px; }
          .btn {
            padding: 0.85rem 2rem;
            border-radius: 100px;
            border: none;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.2s;
            align-self: flex-start;
          }
          .btn:hover { opacity: 0.9; transform: translateY(-2px); }

          /* ── Footer ── */
          footer {
            border-top: 1px solid var(--border);
            padding: 2rem;
            text-align: center;
            color: var(--muted);
            font-size: 0.85rem;
          }

          /* ── Theme toggle ── */
          .theme-toggle {
            background: none;
            border: 1px solid var(--border);
            border-radius: 100px;
            padding: 0.35rem 0.75rem;
            cursor: pointer;
            color: var(--muted);
            font-size: 1rem;
            line-height: 1;
            transition: border-color 0.2s, color 0.2s;
          }
          .theme-toggle:hover { border-color: var(--accent); color: var(--text); }

          /* ── Language switcher ── */
          .lang-switcher { display: flex; gap: 0.4rem; align-items: center; }
          .lang-link {
            color: var(--muted);
            text-decoration: none;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            padding: 0.35rem 0.6rem;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: transparent;
            position: relative;
            transition: color 0.2s, border-color 0.2s, background 0.2s, transform 0.15s;
          }
          .lang-link:hover {
            color: var(--text);
            border-color: var(--accent);
            background: rgba(120, 80, 255, 0.12);
            transform: translateY(-1px);
          }
          .lang-active {
            color: var(--accent) !important;
            border-color: var(--accent) !important;
            background: rgba(120, 80, 255, 0.15) !important;
          }
          .lang-link::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: calc(100% + 6px);
            left: 50%;
            transform: translateX(-50%) translateY(4px);
            background: var(--surface);
            color: var(--text);
            font-size: 0.7rem;
            font-weight: 500;
            letter-spacing: 0.03em;
            white-space: nowrap;
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            border: 1px solid var(--border);
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.15s, transform 0.15s;
          }
          .lang-link:hover::after {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
          }

          @media (max-width: 768px) {
            .about-text, .contact-grid { grid-template-columns: 1fr; }
            .nav-links { display: none; }
          }
        </style>
      </head>
      <body>

        <nav>
          <span class="nav-logo">AutoBot</span>
          <ul class="nav-links">
            <li><a href="#about">#{t[:nav_about]}</a></li>
            <li><a href="#features">#{t[:nav_features]}</a></li>
            <li><a href="#contact">#{t[:nav_contact]}</a></li>
          </ul>
          <div class="lang-switcher">
            <a href="?lang=en" class="lang-link #{'lang-active' if lang == 'en'}" data-tooltip="English">EN</a>
            <a href="?lang=pl" class="lang-link #{'lang-active' if lang == 'pl'}" data-tooltip="Polski">PL</a>
            <a href="?lang=de" class="lang-link #{'lang-active' if lang == 'de'}" data-tooltip="Deutsch">DE</a>
            <a href="?lang=fr" class="lang-link #{'lang-active' if lang == 'fr'}" data-tooltip="Français">FR</a>
          </div>
          <button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">🌙</button>
        </nav>

        <!-- ── Hero ── -->
        <section class="hero">
          <div class="orb orb-1"></div>
          <div class="orb orb-2"></div>
          <div class="orb orb-3"></div>
          <div class="hero-content">
            <div class="badge">#{t[:badge]}</div>
            <h1>
              <span class="gradient">#{t[:hero_title_gradient]}</span><br />
              #{t[:hero_title_rest]}
            </h1>
            <p class="hero-sub">#{t[:hero_sub]}</p>
            <a href="#about" class="hero-cta">#{t[:hero_cta]}</a>
          </div>
        </section>

        <!-- ── About ── -->
        <section id="about">
          <div class="section-label">#{t[:about_label]}</div>
          <div class="about-text">
            <div>
              <h2 class="section-title">#{t[:about_title]}</h2>
              <p>#{t[:about_p1]}</p>
              <p>#{t[:about_p2]}</p>
            </div>
            <div class="about-visual">
              <div class="stat">
                <span class="stat-value">10×</span>
                <span class="stat-label">#{t[:stat1_label]}</span>
              </div>
              <div class="stat-divider"></div>
              <div class="stat">
                <span class="stat-value">80%</span>
                <span class="stat-label">#{t[:stat2_label]}</span>
              </div>
              <div class="stat-divider"></div>
              <div class="stat">
                <span class="stat-value">24/7</span>
                <span class="stat-label">#{t[:stat3_label]}</span>
              </div>
            </div>
          </div>
        </section>

        <!-- ── Features / Key Points ── -->
        <section id="features" style="padding-top: 0;">
          <div class="section-label">#{t[:features_label]}</div>
          <h2 class="section-title">#{t[:features_title]}</h2>
          <p class="section-desc">#{t[:features_desc]}</p>
          <div class="cards">
            <div class="card">
              <div class="card-icon">⚡</div>
              <h3>#{t[:card1_title]}</h3>
              <p>#{t[:card1_desc]}</p>
            </div>
            <div class="card">
              <div class="card-icon">🧠</div>
              <h3>#{t[:card2_title]}</h3>
              <p>#{t[:card2_desc]}</p>
            </div>
            <div class="card">
              <div class="card-icon">🔄</div>
              <h3>#{t[:card3_title]}</h3>
              <p>#{t[:card3_desc]}</p>
            </div>
            <div class="card">
              <div class="card-icon">🛡️</div>
              <h3>#{t[:card4_title]}</h3>
              <p>#{t[:card4_desc]}</p>
            </div>
            <div class="card">
              <div class="card-icon">📊</div>
              <h3>#{t[:card5_title]}</h3>
              <p>#{t[:card5_desc]}</p>
            </div>
            <div class="card">
              <div class="card-icon">🤝</div>
              <h3>#{t[:card6_title]}</h3>
              <p>#{t[:card6_desc]}</p>
            </div>
          </div>
        </section>

        <!-- ── Contact ── -->
        <section id="contact">
          <div class="section-label">#{t[:contact_label]}</div>
          <h2 class="section-title">#{t[:contact_title]}</h2>
          <div class="contact-grid">
            <div class="contact-info">
              <div class="contact-item">
                <strong>#{t[:contact_company_label]}</strong>
                <span>Autobot</span>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_address_label]}</strong>
                <span>123 Innovation Street, Suite 400<br />San Francisco, CA 94105<br />United States</span>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_enquiries_label]}</strong>
                <a href="mailto:hello@autobot.dev">hello@autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_support_label]}</strong>
                <a href="mailto:support@autobot.dev">support@autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_phone_label]}</strong>
                <a href="tel:+14155550123">+1 (415) 555-0123</a>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_website_label]}</strong>
                <a href="https://autobot.dev" target="_blank" rel="noopener">autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>#{t[:contact_hours_label]}</strong>
                <span>#{t[:contact_hours_value]}</span>
              </div>
            </div>
            <form onsubmit="return false;">
              <div class="field">
                <label for="name">#{t[:form_name_label]}</label>
                <input id="name" type="text" placeholder="#{t[:form_name_placeholder]}" />
              </div>
              <div class="field">
                <label for="email">#{t[:form_email_label]}</label>
                <input id="email" type="email" placeholder="#{t[:form_email_placeholder]}" />
              </div>
              <div class="field">
                <label for="message">#{t[:form_message_label]}</label>
                <textarea id="message" placeholder="#{t[:form_message_placeholder]}"></textarea>
              </div>
              <button class="btn" type="submit">#{t[:form_submit]}</button>
            </form>
          </div>
        </section>

        <footer>
          <p>© #{Time.now.year} Autobot. #{t[:footer_rights]}</p>
        </footer>

        <script>
          (function () {
            var STORAGE_KEY = 'autobot-theme';
            var btn = document.getElementById('theme-toggle');

            function applyTheme(theme) {
              document.documentElement.setAttribute('data-theme', theme);
              btn.textContent = theme === 'light' ? '🌙' : '☀️';
              btn.setAttribute('aria-label', theme === 'light' ? 'Switch to dark theme' : 'Switch to light theme');
            }

            function detectSystemTheme() {
              return window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
            }

            var stored = localStorage.getItem(STORAGE_KEY);
            applyTheme(stored || detectSystemTheme());

            btn.addEventListener('click', function () {
              var current = document.documentElement.getAttribute('data-theme') || 'dark';
              var next = current === 'dark' ? 'light' : 'dark';
              localStorage.setItem(STORAGE_KEY, next);
              applyTheme(next);
            });
          })();
        </script>

      </body>
      </html>
    HTML
  end
end
