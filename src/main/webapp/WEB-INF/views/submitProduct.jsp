<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoroccoCraft — Soumettre un produit</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; min-height: 100vh; }

        nav {
            background: #1a0f0a;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
        }
        .nav-logo {
            font-family: 'Playfair Display', serif;
            color: #f4c97a;
            font-size: 20px;
            font-weight: 700;
            text-decoration: none;
        }
        .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 14px;
        }
        .nav-link:hover { color: #f4c97a; }

        .container {
            max-width: 680px;
            margin: 48px auto;
            padding: 0 20px;
        }
        .card {
            background: #faf7f2;
            border-radius: 16px;
            padding: 48px;
            border: 1px solid #e8e0d4;
        }
        .page-header { margin-bottom: 36px; }
        .page-header p { color: #7a6a5a; font-size: 13px; margin-top: 4px; }
        h1 {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            color: #1a0f0a;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 24px;
        }
        .alert-error   { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }

        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #3d2b1f;
            margin-bottom: 6px;
        }
        .required { color: #8b4513; }

        input[type="text"],
        input[type="number"],
        input[type="url"],
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
        textarea { height: 120px; resize: vertical; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        /* Sélection catégorie visuelle */
        .cat-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        .cat-radio { display: none; }
        .cat-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            padding: 14px 8px;
            border: 2px solid #d4c4b0;
            border-radius: 10px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            color: #7a6a5a;
            transition: all .2s;
            text-align: center;
        }
        .cat-label:hover { border-color: #8b4513; }
        .cat-radio:checked + .cat-label {
            border-color: #8b4513;
            background: #fdf5ec;
            color: #6b3410;
        }
        .cat-emoji { font-size: 22px; }

        .btn-submit {
            width: 100%;
            padding: 14px;
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
        .btn-submit:hover { background: #6b3410; }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #7a6a5a;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { color: #8b4513; }
    </style>
</head>
<body>
<%
    User connectedUser = (User) session.getAttribute("user");
    String msg   = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <a class="nav-link" href="<%= request.getContextPath() %>/ProductController">← Retour au catalogue</a>
</nav>

<div class="container">
    <div class="card">
        <div class="page-header">
            <h1>Soumettre un produit</h1>
            <p>Votre produit sera visible après validation par notre équipe.</p>
        </div>

        <% if (msg   != null) { %><div class="alert alert-success"><%= msg   %></div><% } %>
        <% if (error != null) { %><div class="alert alert-error">  <%= error %></div><% } %>

        <form action="<%= request.getContextPath() %>/SubmitProductController" method="post">

            <div class="form-group">
                <label>Titre du produit <span class="required">*</span></label>
                <input type="text" name="title" placeholder="Ex: Tapis Beni Ourain en laine naturelle" required>
            </div>

            <div class="form-group">
                <label>Catégorie <span class="required">*</span></label>
                <div class="cat-grid">
                    <% String[][] categories = {
                        {"Tapis","🏺"}, {"Poterie","🎨"}, {"Bijoux","💎"},
                        {"Cuir","👜"}, {"Laiton","🪔"}, {"Autre","✦"}
                    }; %>
                    <% for (String[] cat : categories) { %>
                        <input type="radio" name="category" id="cat-<%= cat[0] %>"
                               value="<%= cat[0] %>" class="cat-radio" required>
                        <label for="cat-<%= cat[0] %>" class="cat-label">
                            <span class="cat-emoji"><%= cat[1] %></span>
                            <%= cat[0] %>
                        </label>
                    <% } %>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Prix (MAD) <span class="required">*</span></label>
                    <input type="number" name="price" min="0.01" step="0.01"
                           placeholder="Ex: 350.00" required>
                </div>
                <div class="form-group">
                    <label>URL de l'image</label>
                    <input type="url" name="imageUrl" placeholder="https://...">
                </div>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"
                          placeholder="Décrivez votre produit : matériaux utilisés, technique de fabrication, dimensions..."></textarea>
            </div>

            <button type="submit" class="btn-submit">Soumettre pour validation →</button>
        </form>

        <a class="back-link" href="<%= request.getContextPath() %>/ProductController">← Retour au catalogue</a>
    </div>
</div>
</body>
</html>
