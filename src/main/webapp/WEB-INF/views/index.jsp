
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MoroccoCraft — Connexion</title>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; display: flex; min-height: 100vh; overflow-x: hidden; }

/* ===== LEFT PANEL ===== */
.left-panel {
    flex: 1.6;
    position: relative;
    background: url('https://i.imgur.com/epedMhx.png') center/cover no-repeat;
}

.left-panel::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom,
        rgba(0,0,0,0.6) 0%,
        rgba(0,0,0,0.2) 40%,
        rgba(0,0,0,0.2) 60%,
        rgba(0,0,0,0.7) 100%);
}

/* CONTENU GAUCHE CENTRÉ */
.left-content {
    position: absolute;
    inset: 0;
    z-index: 2;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 40px;
    padding: 48px;
}

/* Badge */
.badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(244,201,122,0.5);
    color: #f4c97a;
    padding: 8px 18px;
    border-radius: 24px;
    font-size: 11px;
    letter-spacing: 2px;
    text-transform: uppercase;
}
.badge-dot {
    width: 6px; height: 6px;
    background: #f4c97a;
    border-radius: 50%;
    animation: pulse 2s infinite;
}
@keyframes pulse {
    50% { opacity: 0.4; }
}

/* ===== ANIMATION TITRE ===== */
.left-title {
    font-family: 'Playfair Display', serif;
    font-size: clamp(36px, 4vw, 58px);
    color: #fff;
    line-height: 1.2;
    animation: slideFade 1.2s ease forwards;
    opacity: 0;
}

.left-title em {
    color: #f4c97a;
}

/* Animation */
@keyframes slideFade {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.left-subtitle {
    color: rgba(255,255,255,0.7);
    max-width: 400px;
    animation: fadeIn 2s ease;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* ===== RIGHT PANEL ===== */
.right-panel {
    width: 42%;
    max-width: 560px;
    background: #faf7f2;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 48px;
    box-shadow: -12px 0 48px rgba(0,0,0,0.2);
}

/* Logo */
.logo { display: flex; align-items: center; gap: 12px; margin-bottom: 30px; }
.logo-icon {
    width: 46px; height: 46px;
    background: #1a0f0a;
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    transition: transform .3s;
}
.logo-icon:hover { transform: rotate(-8deg) scale(1.05); }

.logo-name {
    font-family: 'Playfair Display', serif;
    font-size: 22px;
}

/* Form */
.form-title { font-size: 32px; margin-bottom: 10px; }
.form-sub { color: #7a6a5a; margin-bottom: 25px; }

.form-group { margin-bottom: 16px; }
.field-label { font-size: 12px; font-weight: 600; }

.field-wrap { position: relative; }
.field-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
}

input {
    width: 100%;
    padding: 12px 12px 12px 38px;
    border: 1.5px solid #ddd;
    border-radius: 10px;
    transition: all .2s;
}
input:focus {
    border-color: #9a4515;
    box-shadow: 0 0 0 4px rgba(154,69,21,0.15);
    transform: scale(1.01);
}

/* Button */
.btn-login {
    width: 100%;
    padding: 14px;
    background: linear-gradient(135deg, #9a4515, #7a3210, #9a4515);
    background-size: 200% 200%;
    color: white;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: .3s;
}
.btn-login:hover {
    background-position: right center;
    transform: translateY(-2px);
    box-shadow: 0 10px 28px rgba(139,69,19,0.4);
}

/* Footer */
.form-footer { text-align: center; margin-top: 20px; }
.form-footer a { color: #8b4513; }

.secure { text-align: center; margin-top: 20px; font-size: 12px; color: #aaa; }

/* Responsive */
@media (max-width: 960px) {
    .left-panel { display: none; }
    .right-panel { width: 100%; }
}
</style>
</head>

<body>

<!-- LEFT -->
<div class="left-panel">
    <div class="left-content">

        <div class="badge">
            <div class="badge-dot"></div>
            Artisanat Marocain
        </div>

        <div>
            <h1 class="left-title">
                Entrez dans un monde<br>
                d'<em>artisanat authentique</em>
            </h1>

            <p class="left-subtitle">
                Découvrez des créations uniques faites par des artisans marocains.
            </p>
        </div>

    </div>
</div>

<!-- RIGHT -->
<div class="right-panel">

    <div class="logo">
        <div class="logo-icon">🏺</div>
        <div class="logo-name">MoroccoCraft</div>
    </div>

    <h1 class="form-title">Connexion</h1>
    <p class="form-sub">Connectez-vous à votre compte</p>

    <form action="<%= request.getContextPath() %>/LoginController" method="post">

        <div class="form-group">
            <label class="field-label">Email</label>
            <div class="field-wrap">
                <span class="field-icon">✉</span>
                <input type="email" name="email" required>
            </div>
        </div>

        <div class="form-group">
            <label class="field-label">Mot de passe</label>
            <div class="field-wrap">
                <span class="field-icon">🔒</span>
                <input type="password" name="password" required>
            </div>
        </div>

        <button class="btn-login">Se connecter →</button>

    </form>

    <div class="form-footer">
        Pas encore de compte ?
        <a href="<%= request.getContextPath() %>/RegisterController">Créer un compte</a>
    </div>

    <div class="secure">🔒 Connexion sécurisée</div>

</div>

</body>
</html>

