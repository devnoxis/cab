# frozen_string_literal: true

require 'rack'
require 'json'
require 'securerandom'
require 'base64'

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/'
      [200, { 'content-type' => 'application/json' }, [{ message: 'Welcome' }.to_json]]
    elsif request.path == '/up'
      [200, { 'content-type' => 'application/json' }, [{ message: "I'm wokring" }.to_json]]
    elsif request.path == '/info'
      [200, { 'content-type' => 'application/json' }, [{ app: 'Test', date: Time.now.strftime('%Y-%m-%d'), ruby_version: RUBY_VERSION }.to_json]]
    elsif request.path == '/about'
      [200, { 'content-type' => 'text/html' }, [about_html]]
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

  def about_html
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
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
            background: rgba(10, 10, 15, 0.8);
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
            <li><a href="#about">About</a></li>
            <li><a href="#features">Features</a></li>
            <li><a href="#contact">Contact</a></li>
          </ul>
        </nav>

        <!-- ── Hero ── -->
        <section class="hero">
          <div class="orb orb-1"></div>
          <div class="orb orb-2"></div>
          <div class="orb orb-3"></div>
          <div class="hero-content">
            <div class="badge">Powered by Artificial Intelligence</div>
            <h1>
              <span class="gradient">AutoBot AI workflow</span><br />
              is near
            </h1>
            <p class="hero-sub">
              The future of digital product development is here. Build faster, smarter,
              and more reliably by putting AI at the heart of your workflow.
            </p>
            <a href="#about" class="hero-cta">Discover how ↓</a>
          </div>
        </section>

        <!-- ── About ── -->
        <section id="about">
          <div class="section-label">About</div>
          <div class="about-text">
            <div>
              <h2 class="section-title">AI is reshaping how digital products are built</h2>
              <p>
                Today, artificial intelligence isn't just a tool — it's a co-creator.
                From generating code and content to automating repetitive tasks and
                surfacing insights, AI enables teams to ship digital products at a pace
                and quality that was simply not possible before.
              </p>
              <p>
                Whether you're designing a mobile app, a web platform, or a complex
                backend system, integrating AI into your workflow reduces friction,
                accelerates iteration, and helps you focus on what matters most:
                delivering value to your users.
              </p>
            </div>
            <div class="about-visual">
              <div class="stat">
                <span class="stat-value">10×</span>
                <span class="stat-label">Faster prototype-to-production cycles</span>
              </div>
              <div class="stat-divider"></div>
              <div class="stat">
                <span class="stat-value">80%</span>
                <span class="stat-label">Reduction in repetitive engineering tasks</span>
              </div>
              <div class="stat-divider"></div>
              <div class="stat">
                <span class="stat-value">24/7</span>
                <span class="stat-label">AI-assisted code review &amp; testing</span>
              </div>
            </div>
          </div>
        </section>

        <!-- ── Features / Key Points ── -->
        <section id="features" style="padding-top: 0;">
          <div class="section-label">Key Points</div>
          <h2 class="section-title">Why AI belongs in your product workflow</h2>
          <p class="section-desc">
            These are the capabilities that make AI an indispensable partner for any modern digital team.
          </p>
          <div class="cards">
            <div class="card">
              <div class="card-icon">⚡</div>
              <h3>Accelerated Development</h3>
              <p>AI-assisted coding, scaffolding, and boilerplate generation cut time-to-first-commit dramatically so your team ships features faster.</p>
            </div>
            <div class="card">
              <div class="card-icon">🧠</div>
              <h3>Intelligent Code Review</h3>
              <p>Automated analysis catches bugs, security vulnerabilities, and style issues before they reach production — at any hour of the day.</p>
            </div>
            <div class="card">
              <div class="card-icon">🔄</div>
              <h3>Continuous Iteration</h3>
              <p>AI learns from your feedback loops, making every subsequent release smarter and more aligned with your users' real needs.</p>
            </div>
            <div class="card">
              <div class="card-icon">🛡️</div>
              <h3>Built-in Quality</h3>
              <p>Generate tests, documentation, and observability instrumentation alongside your code — quality baked in, not bolted on.</p>
            </div>
            <div class="card">
              <div class="card-icon">📊</div>
              <h3>Data-Driven Decisions</h3>
              <p>AI surfaces patterns in usage data and error reports so product and engineering teams can prioritize with confidence.</p>
            </div>
            <div class="card">
              <div class="card-icon">🤝</div>
              <h3>Human + AI Collaboration</h3>
              <p>AI handles the mechanical; humans handle the creative. Together, you build products with more empathy and fewer defects.</p>
            </div>
          </div>
        </section>

        <!-- ── Contact ── -->
        <section id="contact">
          <div class="section-label">Contact</div>
          <h2 class="section-title">Get in touch</h2>
          <div class="contact-grid">
            <div class="contact-info">
              <div class="contact-item">
                <strong>Company</strong>
                <span>Autobot</span>
              </div>
              <div class="contact-item">
                <strong>Address</strong>
                <span>123 Innovation Street, Suite 400<br />San Francisco, CA 94105<br />United States</span>
              </div>
              <div class="contact-item">
                <strong>General Enquiries</strong>
                <a href="mailto:hello@autobot.dev">hello@autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>Support</strong>
                <a href="mailto:support@autobot.dev">support@autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>Phone</strong>
                <a href="tel:+14155550123">+1 (415) 555-0123</a>
              </div>
              <div class="contact-item">
                <strong>Website</strong>
                <a href="https://autobot.dev" target="_blank" rel="noopener">autobot.dev</a>
              </div>
              <div class="contact-item">
                <strong>Business Hours</strong>
                <span>Monday–Friday, 9:00 AM – 6:00 PM PST</span>
              </div>
            </div>
            <form onsubmit="return false;">
              <div class="field">
                <label for="name">Name</label>
                <input id="name" type="text" placeholder="Your name" />
              </div>
              <div class="field">
                <label for="email">Email</label>
                <input id="email" type="email" placeholder="you@example.com" />
              </div>
              <div class="field">
                <label for="message">Message</label>
                <textarea id="message" placeholder="How can we help?"></textarea>
              </div>
              <button class="btn" type="submit">Send message →</button>
            </form>
          </div>
        </section>

        <footer>
          <p>© #{Time.now.year} Autobot. All rights reserved.</p>
        </footer>

      </body>
      </html>
    HTML
  end
end
