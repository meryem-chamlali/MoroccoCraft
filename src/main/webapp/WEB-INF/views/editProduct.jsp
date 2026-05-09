<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ma.ac.esi.moroccocraft.model.Product" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>MoroccoCraft — Modifier le produit</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f0e8; min-height: 100vh; }
        nav {
            background: #1a0f0a; padding: 0 40px;
            display: flex; align-items: center; justify-content: space-between; height: 60px;
        }
        .nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
        .nav-link  { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
        .nav-link:hover { color: #f4c97a; }
        .container { max-width: 680px; margin: 48px auto; padding: 0 20px; }
        .card { background: #faf7f2; border-radius: 16px; padding: 48px; border: 1px solid #e8e0d4; }
        h1 { font-family: 'Playfair Display', serif; font-size: 26px; color: #1a0f0a; margin-bottom: 6px; }
        .subtitle { color: #7a6a5a; font-size: 13px; margin-bottom: 32px; }
        .alert { padding: 12px 16px; border-radius: 8px; font-size: 14px; margin-bottom: 20px; }
        .alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-size: 13px; font-weight: 500; color: #3d2b1f; margin-bottom: 6px; }
        input[type="text"], input[type="number"], input[type="url"], select, textarea {
            width: 100%; padding: 11px 14px; border: 1.5px solid #d4c4b0;
            border-radius: 8px; font-size: 14px; font-family: 'Inter', sans-serif;
            background: #fff; color: #1a0f0a; outline: none; transition: border-color .2s;
        }
        input:focus, select:focus, textarea:focus { border-color: #8b4513; }
        textarea { height: 120px; resize: vertical; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-save {
            padding: 13px 32px; background: #8b4513; color: #fff;
            border: none; border-radius: 8px; font-size: 15px;
            font-weight: 500; font-family: 'Inter', sans-serif; cursor: pointer; transition: background .2s;
        }
        .btn-save:hover { background: #6b3410; }
        .btn-cancel {
            padding: 13px 24px; background: transparent; color: #7a6a5a;
            border: 1.5px solid #d4c4b0; border-radius: 8px; font-size: 15px;
            font-family: 'Inter', sans-serif; cursor: pointer; margin-left: 12px; text-decoration: none;
            display: inline-block; transition: border-color .2s;
        }
        .btn-cancel:hover { border-color: #8b4513; color: #8b4513; }
        .status-badge {
            display: inline-block; padding: 4px 12px; border-radius: 12px;
            font-size: 12px; font-weight: 600; margin-bottom: 24px;
        }
        .status-PENDING  { background: #fef9c3; color: #854d0e; }
        .status-APPROVED { background: #dcfce7; color: #166534; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>
<%
    Product product = (Product) request.getAttribute("product");
    String error    = (String)  request.getAttribute("error");
%>
<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <a class="nav-link"  href="<%= request.getContextPath() %>/MyProductsController">← Mes produits</a>
</nav>
<div class="container">
  <div class="card">
    <h1>Modifier le produit</h1>
    <p class="subtitle">Les modifications remettront le produit en attente de validation.</p>

    <% if (product != null) { %>
    <span class="status-badge status-<%= product.getStatus() %>"><%= product.getStatus() %></span>
    <% } %>

    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <% if (product != null) { %>
    <form action="<%= request.getContextPath() %>/EditProductController" method="post">
        <input type="hidden" name="id" value="<%= product.getId() %>">

        <div class="form-group">
            <label>Titre *</label>
            <input type="text" name="title" value="<%= product.getTitle() %>" required>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Prix (MAD) *</label>
                <input type="number" name="price" step="0.01" min="0.01"
                       value="<%= product.getPrice() %>" required>
            </div>
            <div class="form-group">
                <label>Catégorie *</label>
                <select name="category">
                    <% String[] cats = {"Tapis","Poterie","Bijoux","Cuir","Laiton","Autre"};
                       for (String cat : cats) { %>
                        <option value="<%= cat %>" <%= cat.equals(product.getCategory()) ? "selected" : "" %>><%= cat %></option>
                    <% } %>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label>URL de l'image</label>
            <input type="url" name="imageUrl"
                   value="<%= product.getImageUrl() != null ? product.getImageUrl() : "" %>">
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
        </div>

        <button type="submit" class="btn-save">💾 Enregistrer</button>
        <a class="btn-cancel" href="<%= request.getContextPath() %>/MyProductsController">Annuler</a>
    </form>
    <% } %>
  </div>
</div>
</body>
</html>
