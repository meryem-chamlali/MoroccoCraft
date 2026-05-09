<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="ma.ac.esi.moroccocraft.model.Product" %>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoroccoCraft — Catalogue</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,400&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; }

        /* ---- Navbar ---- */
        nav {
            background: #1a0f0a;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-link { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; transition: color .2s; }
        .nav-link:hover { color: #f4c97a; }

        /* Bouton artisan dans la navbar — très visible */
        .nav-btn-artisan {
            display: flex; align-items: center; gap: 6px;
            background: #8b4513; color: #fff;
            padding: 8px 16px; border-radius: 8px;
            text-decoration: none; font-size: 13px; font-weight: 500;
            transition: background .2s;
        }
        .nav-btn-artisan:hover { background: #6b3410; color: #fff; }

        .nav-separator { width: 1px; height: 24px; background: rgba(255,255,255,0.15); }

        .nav-user { color: rgba(255,255,255,0.6); font-size: 13px; }
        .nav-user strong { color: #f4c97a; }

        .btn-logout {
            background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.7); padding: 7px 14px; border-radius: 6px;
            font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif; transition: all .2s;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.15); color: #fff; }

        /* ---- Bannière artisan ---- */
        .artisan-banner {
            background: linear-gradient(90deg, #2c1810, #5c3320);
            border-bottom: 2px solid #8b4513;
            padding: 14px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .artisan-banner-left { display: flex; align-items: center; gap: 12px; }
        .artisan-banner-icon { font-size: 22px; }
        .artisan-banner-text { color: rgba(255,255,255,0.85); font-size: 14px; }
        .artisan-banner-text strong { color: #f4c97a; }
        .artisan-actions { display: flex; gap: 10px; }
        .btn-banner {
            padding: 8px 18px; border-radius: 8px; font-size: 13px; font-weight: 500;
            font-family: 'Inter', sans-serif; cursor: pointer; text-decoration: none;
            transition: all .2s; border: none;
        }
        .btn-banner-primary { background: #f4c97a; color: #2c1810; }
        .btn-banner-primary:hover { background: #f0be5a; }
        .btn-banner-secondary { background: rgba(255,255,255,0.12); color: #fff; border: 1px solid rgba(255,255,255,0.25); }
        .btn-banner-secondary:hover { background: rgba(255,255,255,0.2); }

        /* ---- Hero ---- */
        .hero {
            background: linear-gradient(135deg, #2c1810 0%, #5c3320 100%);
            padding: 56px 40px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23cd853f' fill-opacity='0.06'%3E%3Cpath d='M20 0l4 8-4 8-4-8zm0 24l4 8-4 8-4-8zM0 20l8-4 8 4-8 4zm24 0l8-4 8 4-8 4z'/%3E%3C/g%3E%3C/svg%3E");
        }
        .hero-label { display: inline-block; color: #f4c97a; font-size: 11px; font-weight: 500; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 14px; position: relative; }
        .hero h1 { font-family: 'Playfair Display', serif; font-size: 36px; color: #fff; line-height: 1.2; position: relative; }
        .hero h1 em { color: #f4c97a; font-style: italic; }
        .hero-sub { color: rgba(255,255,255,0.6); font-size: 15px; margin-top: 10px; position: relative; }

        /* ---- Filtres ---- */
        .filters-bar {
            background: #fff; border-bottom: 1px solid #e8e0d4;
            padding: 0 40px; display: flex; align-items: center; gap: 8px;
            overflow-x: auto; height: 56px;
        }
        .filter-btn {
            white-space: nowrap; padding: 7px 18px; border-radius: 20px;
            border: 1.5px solid #d4c4b0; background: transparent;
            font-size: 13px; font-family: 'Inter', sans-serif; color: #5a4a3a;
            cursor: pointer; text-decoration: none; transition: all .2s;
        }
        .filter-btn:hover, .filter-btn.active { background: #8b4513; border-color: #8b4513; color: #fff; }

        /* ---- Grille ---- */
        .main { max-width: 1200px; margin: 0 auto; padding: 40px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 22px; color: #1a0f0a; margin-bottom: 4px; }
        .section-sub { color: #7a6a5a; font-size: 14px; margin-bottom: 32px; }
        .section-sub em { color: #8b4513; font-style: italic; }

        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }

        .card {
            background: #fff; border-radius: 12px; overflow: hidden;
            border: 1px solid #e8e0d4; transition: transform .2s, box-shadow .2s;
            display: flex; flex-direction: column;
        }
        .card:hover { transform: translateY(-4px); box-shadow: 0 8px 32px rgba(44,24,16,0.12); }

        .card-img {
            width: 100%; height: 200px; object-fit: cover;
            display: flex; align-items: center; justify-content: center; font-size: 48px;
        }
        .cat-Tapis   { background: linear-gradient(135deg,#fef3c7,#fde68a); }
        .cat-Poterie { background: linear-gradient(135deg,#e8ddd0,#d4c4b0); }
        .cat-Bijoux  { background: linear-gradient(135deg,#fef9c3,#fef08a); }
        .cat-Cuir    { background: linear-gradient(135deg,#fed7aa,#fdba74); }
        .cat-Laiton  { background: linear-gradient(135deg,#d1fae5,#a7f3d0); }
        .cat-Autre   { background: linear-gradient(135deg,#e0e7ff,#c7d2fe); }

        .card-body { padding: 18px; flex: 1; display: flex; flex-direction: column; }
        .card-category { font-size: 11px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; color: #8b4513; margin-bottom: 8px; }
        .card-title { font-family: 'Playfair Display', serif; font-size: 17px; color: #1a0f0a; margin-bottom: 6px; font-weight: 700; }
        .card-artisan { font-size: 13px; color: #7a6a5a; margin-bottom: 12px; }

        .card-footer { display: flex; align-items: center; justify-content: space-between; margin-top: auto; }
        .card-price { font-size: 20px; font-weight: 700; color: #1a0f0a; }
        .card-price span { font-size: 13px; font-weight: 400; color: #7a6a5a; }

        .btn-cart {
            padding: 8px 18px; background: #1a0f0a; color: #fff; border: none;
            border-radius: 6px; font-size: 13px; font-family: 'Inter', sans-serif;
            cursor: pointer; transition: background .2s;
        }
        .btn-cart:hover { background: #8b4513; }

        /* ---- Boutons CRUD sur la carte (pour artisan propriétaire) ---- */
        .card-crud {
            display: flex; gap: 6px; padding: 12px 18px;
            border-top: 1px solid #f0e8dc; background: #faf7f2;
        }
        .btn-crud-edit {
            flex: 1; padding: 8px; background: #fdf5ec; color: #8b4513;
            border: 1px solid #f4d5b8; border-radius: 6px; font-size: 12px; font-weight: 500;
            font-family: 'Inter', sans-serif; cursor: pointer; text-decoration: none;
            text-align: center; transition: all .2s;
        }
        .btn-crud-edit:hover { background: #f4d5b8; }

        .btn-crud-delete {
            flex: 1; padding: 8px; background: #fee2e2; color: #991b1b;
            border: 1px solid #fecaca; border-radius: 6px; font-size: 12px; font-weight: 500;
            font-family: 'Inter', sans-serif; cursor: pointer;
            text-align: center; transition: all .2s;
        }
        .btn-crud-delete:hover { background: #fecaca; }

        /* Badge statut sur la carte (pour artisan) */
        .card-status {
            display: inline-block; padding: 3px 10px; border-radius: 10px;
            font-size: 11px; font-weight: 600; margin-bottom: 10px;
        }
        .status-PENDING  { background: #fef9c3; color: #854d0e; }
        .status-APPROVED { background: #dcfce7; color: #166534; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; }

        .empty-state { text-align: center; padding: 80px 20px; color: #7a6a5a; }
        .empty-state p { font-size: 15px; margin-top: 8px; }
    </style>
</head>
<body>
<%
    User connectedUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    boolean isArtisan = connectedUser != null && connectedUser.isArtisan();
    boolean isAdmin   = connectedUser != null && connectedUser.isAdmin();
%>

<!-- Navbar -->
<nav>
    <a class="nav-logo" href="#">🏺 MoroccoCraft</a>
    <div class="nav-right">
        <% if (isAdmin) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/AdminController">⚙ Panneau Admin</a>
            <div class="nav-separator"></div>
        <% } %>
        <% if (isArtisan) { %>
            <div class="nav-separator"></div>
        <% } %>
        <% if (connectedUser != null && connectedUser.isBuyer()) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/CartController"
               style="display:flex;align-items:center;gap:5px;background:rgba(244,201,122,0.1);
                      border:1px solid rgba(244,201,122,0.3);padding:6px 14px;border-radius:20px;color:#f4c97a">
                🛍 Mon panier
            </a>
            <div class="nav-separator"></div>
        <% } %>
        <span class="nav-user">Bonjour, <strong><%= connectedUser != null ? connectedUser.getName() : "Visiteur" %></strong></span>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<!-- Bannière artisan — liens uniquement ici, pas dans la navbar -->
<% if (isArtisan) { %>
<div class="artisan-banner">
    <div class="artisan-banner-left">
        <span class="artisan-banner-icon">🎨</span>
        <span class="artisan-banner-text">
            Espace artisan — <strong><%= connectedUser.getName() %></strong>
        </span>
    </div>
    <div class="artisan-actions">
        <a class="btn-banner btn-banner-primary"
           href="<%= request.getContextPath() %>/SubmitProductController">+ Ajouter un produit</a>
        <a class="btn-banner btn-banner-secondary"
           href="<%= request.getContextPath() %>/MyProductsController">📦 Mes produits</a>
        <a class="btn-banner btn-banner-secondary"
           href="<%= request.getContextPath() %>/OrderController">📬 Commandes reçues</a>
    </div>
</div>
<% } %>

<!-- Hero -->
<div class="hero">
    <div class="hero-label">✦ Sélection Curatée</div>
    <h1>Enraciné dans les pratiques ancestrales,<br>conçu pour la <em>maison moderne</em>.</h1>
    <p class="hero-sub">Des artisans marocains directement à votre porte.</p>
</div>

<!-- Filtres -->
<div class="filters-bar">
    <a class="filter-btn <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>"
       href="<%= request.getContextPath() %>/ProductController">Tout</a>
    <% String[] cats = {"Tapis","Poterie","Bijoux","Cuir","Laiton","Autre"}; %>
    <% for (String cat : cats) { %>
        <a class="filter-btn <%= cat.equals(selectedCategory) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/ProductController?category=<%= cat %>"><%= cat %></a>
    <% } %>
</div>

<!-- Catalogue -->
<div class="main">
    <h2 class="section-title">Notre Collection</h2>
    <p class="section-sub">
        <% if (selectedCategory != null && !selectedCategory.isEmpty()) { %>
            Catégorie : <em><%= selectedCategory %></em> —
        <% } %>
        <%= products != null ? products.size() : 0 %> produit(s) disponible(s)
    </p>

    <% if (products == null || products.isEmpty()) { %>
        <div class="empty-state">
            <div style="font-size:56px">🎨</div>
            <p>Aucun produit disponible dans cette catégorie pour le moment.</p>
            <% if (isArtisan) { %>
                <p style="margin-top:12px">
                    <a href="<%= request.getContextPath() %>/SubmitProductController"
                       style="color:#8b4513;font-weight:500;text-decoration:none">
                        → Soyez le premier à ajouter un produit !
                    </a>
                </p>
            <% } %>
        </div>
    <% } else { %>
        <div class="grid">
        <%
            String[] catEmojis = {"🏺","🎨","💎","👜","🪔","✦"};
            String[] catNames  = {"Tapis","Poterie","Bijoux","Cuir","Laiton","Autre"};
            for (Product p : products) {
                String emoji = "🏺";
                for (int i = 0; i < catNames.length; i++) {
                    if (catNames[i].equals(p.getCategory())) { emoji = catEmojis[i]; break; }
                }
                // L'artisan est-il propriétaire de ce produit ?
                boolean isOwner = isArtisan && connectedUser != null && p.getArtisanId() == connectedUser.getId();
        %>
            <div class="card">
                <!-- Image -->
                <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                    <img class="card-img" src="<%= p.getImageUrl() %>" alt="<%= p.getTitle() %>">
                <% } else { %>
                    <div class="card-img cat-<%= p.getCategory() %>"><%= emoji %></div>
                <% } %>

                <!-- Corps -->
                <div class="card-body">
                    <div class="card-category"><%= p.getCategory() %></div>

                    <!-- Badge statut visible uniquement pour le propriétaire -->
                    <% if (isOwner || isAdmin) { %>
                        <span class="card-status status-<%= p.getStatus() %>">
                            <%= "PENDING".equals(p.getStatus())  ? "⏳ En attente"  :
                                "APPROVED".equals(p.getStatus()) ? "✅ Approuvé"    : "❌ Rejeté" %>
                        </span>
                    <% } %>

                    <div class="card-title"><%= p.getTitle() %></div>
                    <div class="card-artisan">
                        Par <%= p.getArtisanName() %>
                        <% if (p.getArtisanCity() != null) { %> — <%= p.getArtisanCity() %><% } %>
                    </div>
                    <div class="card-footer">
                        <div class="card-price"><%= String.format("%.2f", p.getPrice()) %> <span>MAD</span></div>
                        <% if (connectedUser != null && connectedUser.isBuyer()) { %>
                            <form action="<%= request.getContextPath() %>/CartController" method="post" style="margin:0">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" value="<%= p.getId() %>">
                                <button type="submit" class="btn-cart">🛍 Ajouter au panier</button>
                            </form>
                        <% } %>

                    </div>
                </div>

                <!-- Boutons CRUD si l'artisan est propriétaire OU admin -->
                <% if (isOwner || isAdmin) { %>
                <div class="card-crud">
                    <a class="btn-crud-edit"
                       href="<%= request.getContextPath() %>/EditProductController?id=<%= p.getId() %>">
                        ✏ Modifier
                    </a>
                    <form style="flex:1;margin:0"
                          action="<%= request.getContextPath() %>/DeleteProductController" method="post"
                          onsubmit="return confirm('Supprimer « <%= p.getTitle() %> » définitivement ?')">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <button type="submit" class="btn-crud-delete" style="width:100%">🗑 Supprimer</button>
                    </form>
                </div>
                <% } %>

            </div>
        <% } %>
        </div>
    <% } %>
</div>

</body>
</html>
