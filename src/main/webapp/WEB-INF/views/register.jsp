<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoroccoCraft — Inscription</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,400&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f0e8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 16px;
        }
        .card {
            background: #faf7f2;
            border-radius: 16px;
            padding: 48px;
            width: 100%;
            max-width: 560px;
            box-shadow: 0 4px 32px rgba(44,24,16,0.08);
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 32px;
        }
        .logo-icon {
            width: 32px;
            height: 32px;
            background: #2c1810;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .logo-text {
            font-family: 'Playfair Display', serif;
            font-size: 18px;
            color: #2c1810;
            font-weight: 700;
        }
        h1 {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            color: #1a0f0a;
            margin-bottom: 6px;
        }
        .subtitle { color: #7a6a5a; font-size: 14px; margin-bottom: 32px; }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .alert-error   { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { margin-bottom: 18px; }
        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #3d2b1f;
            margin-bottom: 6px;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select,
        textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #d4c4b0;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            background: #fff;
            color: #1a0f0a;
            outline: none;
            transition: border-color .2s;
        }
        input:focus, select:focus, textarea:focus { border-color: #8b4513; }
        textarea { height: 90px; resize: vertical; }

        /* Sélection du rôle avec style visuel */
        .role-group { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 18px; }
        .role-option { display: none; }
        .role-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            padding: 16px 12px;
            border: 2px solid #d4c4b0;
            border-radius: 10px;
            cursor: pointer;
            transition: all .2s;
            font-size: 13px;
            font-weight: 500;
            color: #7a6a5a;
        }
        .role-label:hover { border-color: #8b4513; }
        .role-option:checked + .role-label {
            border-color: #8b4513;
            background: #fdf5ec;
            color: #6b3410;
        }
        .role-icon { font-size: 24px; }

        .btn-primary {
            width: 100%;
            padding: 13px;
            background: #8b4513;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            margin-top: 8px;
            transition: background .2s;
        }
        .btn-primary:hover { background: #6b3410; }
        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #7a6a5a;
        }
        .form-footer a { color: #8b4513; text-decoration: none; font-weight: 500; }

        /* Note artisan */
        #artisan-note {
            display: none;
            background: #fffbeb;
            border: 1px solid #fcd34d;
            color: #92400e;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <div class="logo-icon">🏺</div>
        <span class="logo-text">MoroccoCraft</span>
    </div>
    <h1>Créer un compte</h1>
    <p class="subtitle">Rejoignez la communauté de l'artisanat marocain.</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <form action="<%= request.getContextPath() %>/RegisterController" method="post">

        <!-- Choix du rôle -->
        <label style="margin-bottom:10px">Je suis...</label>
        <div class="role-group">
            <input type="radio" name="role" id="role-buyer" value="BUYER" class="role-option"
                   <%= "BUYER".equals(request.getAttribute("role")) || request.getAttribute("role")==null ? "checked" : "" %>
                   onchange="updateNote()">
            <label for="role-buyer" class="role-label">
                <span class="role-icon">🛍️</span> Acheteur
            </label>

            <input type="radio" name="role" id="role-artisan" value="ARTISAN" class="role-option"
                   <%= "ARTISAN".equals(request.getAttribute("role")) ? "checked" : "" %>
                   onchange="updateNote()">
            <label for="role-artisan" class="role-label">
                <span class="role-icon">🎨</span> Artisan
            </label>
        </div>

        <div id="artisan-note">
            ℹ️ En tant qu'artisan, votre compte sera soumis à validation par notre équipe avant activation.
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="name">Nom complet *</label>
                <input type="text" id="name" name="name" required
                       value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>">
            </div>
            <div class="form-group">
                <label for="city">Ville</label>
                <input type="text" id="city" name="city"
                       value="<%= request.getAttribute("city") != null ? request.getAttribute("city") : "" %>">
            </div>
        </div>

        <div class="form-group">
            <label for="email">Adresse email *</label>
            <input type="email" id="email" name="email" required
                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
        </div>

        <div class="form-group">
            <label for="password">Mot de passe * (6 caractères min.)</label>
            <input type="password" id="password" name="password" required minlength="6">
        </div>

        <div class="form-group">
            <label for="bio">Bio / Présentation <span style="color:#9a8a7a">(artisans)</span></label>
            <textarea id="bio" name="bio" placeholder="Décrivez votre savoir-faire, vos spécialités..."></textarea>
        </div>

        <button type="submit" class="btn-primary">Créer mon compte →</button>
    </form>

    <p class="form-footer">
        Déjà inscrit ? <a href="<%= request.getContextPath() %>/LoginController">Se connecter</a>
    </p>
</div>

<script>
function updateNote() {
    const isArtisan = document.getElementById('role-artisan').checked;
    document.getElementById('artisan-note').style.display = isArtisan ? 'block' : 'none';
}
// Initialisation au chargement
updateNote();
</script>
</body>
</html>
