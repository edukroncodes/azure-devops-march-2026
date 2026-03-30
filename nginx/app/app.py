import socket
from flask import Flask, jsonify, render_template_string
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1)
HOSTNAME = socket.gethostname()

HTML = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask + Nginx + Docker</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }
        .card {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 20px;
            padding: 3rem 4rem;
            text-align: center;
            max-width: 560px;
            width: 90%;
            box-shadow: 0 25px 50px rgba(0,0,0,0.4);
        }
        .badge-row {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }
        .badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .badge-flask  { background: #2d6a4f; color: #b7e4c7; }
        .badge-nginx  { background: #1b4332; color: #52b788; }
        .badge-docker { background: #023e8a; color: #90e0ef; }
        h1 { font-size: 2rem; margin-bottom: 0.5rem; font-weight: 700; }
        .subtitle { color: rgba(255,255,255,0.6); margin-bottom: 2rem; font-size: 1rem; }
        .status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(82,183,136,0.15);
            border: 1px solid #52b788;
            border-radius: 30px;
            padding: 8px 20px;
            font-size: 0.95rem;
            color: #52b788;
            margin-bottom: 2rem;
        }
        .dot {
            width: 10px; height: 10px;
            background: #52b788;
            border-radius: 50%;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(0.7); }
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 1.5rem;
        }
        .info-item {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 12px;
        }
        .info-label { font-size: 0.72rem; color: rgba(255,255,255,0.4); text-transform: uppercase; letter-spacing: 1px; }
        .info-value { font-size: 1rem; font-weight: 600; margin-top: 4px; }
        .instance-banner {
            margin-top: 1.5rem;
            background: rgba(144,224,239,0.1);
            border: 1px solid rgba(144,224,239,0.35);
            border-radius: 10px;
            padding: 10px 16px;
            font-size: 0.85rem;
            color: #90e0ef;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .instance-banner strong { color: #fff; font-family: monospace; font-size: 0.95rem; }
        .endpoint {
            margin-top: 2rem;
            background: rgba(0,0,0,0.3);
            border-radius: 10px;
            padding: 14px 16px;
            font-family: monospace;
            font-size: 0.9rem;
            color: #90e0ef;
            text-align: left;
        }
        .endpoint span { color: rgba(255,255,255,0.35); }
    </style>
</head>
<body>
    <div class="card">
        <div class="badge-row">
            <span class="badge badge-flask">Flask</span>
            <span class="badge badge-nginx">Nginx</span>
            <span class="badge badge-docker">Docker</span>
        </div>
        <h1>App is Running</h1>
        <p class="subtitle">Python Flask served through Nginx in Docker</p>
        <div class="status">
            <div class="dot"></div>
            All systems operational
        </div>
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Framework</div>
                <div class="info-value">Flask</div>
            </div>
            <div class="info-item">
                <div class="info-label">Proxy</div>
                <div class="info-value">Nginx</div>
            </div>
            <div class="info-item">
                <div class="info-label">Container</div>
                <div class="info-value">Docker</div>
            </div>
            <div class="info-item">
                <div class="info-label">Port</div>
                <div class="info-value">80</div>
            </div>
        </div>
        <div class="instance-banner">
            &#9654; Served by instance &nbsp;<strong>{{ hostname }}</strong>
        </div>
        <div class="endpoint">
            <span>GET</span> /health &nbsp;→ health check<br>
            <span>GET</span> /api/info &nbsp;→ app info (JSON)
        </div>
    </div>
</body>
</html>
"""


@app.route("/")
def index():
    return render_template_string(HTML, hostname=HOSTNAME)


@app.route("/health")
def health():
    return jsonify({"status": "ok", "instance": HOSTNAME}), 200


@app.route("/api/info")
def info():
    return jsonify({
        "app": "Flask + Nginx + Docker",
        "version": "1.0.0",
        "instance": HOSTNAME,
        "stack": ["Python", "Flask", "Gunicorn", "Nginx", "Docker"],
        "load_balancing": "round-robin",
        "status": "running"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
