<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, ma.ac.esi.moroccocraft.model.Order, ma.ac.esi.moroccocraft.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>MoroccoCraft — Mes commandes</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; min-height: 100vh; }
nav { background: #1a0f0a; padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 60px; }
.nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link  { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
.nav-link:hover { color: #f4c97a; }
.btn-logout { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: rgba(255,255,255,0.7); padding: 7px 14px; border-radius: 6px; font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif; }

.main { max-width: 900px; margin: 48px auto; padding: 0 20px; }
.flash { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; padding: 14px 18px; border-radius: 10px; margin-bottom: 24px; font-size: 14px; }

.page-title { font-family: 'Playfair Display', serif; font-size: 28px; color: #1a0f0a; margin-bottom: 6px; }
.page-sub   { color: #7a6a5a; font-size: 14px; margin-bottom: 32px; }

.order-card {
    background: #fff; border-radius: 14px; border: 1px solid #e8e0d4;
    padding: 24px; margin-bottom: 18px; transition: box-shadow .2s;
}
.order-card:hover { box-shadow: 0 4px 20px rgba(44,24,16,0.08); }

.order-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 18px; }
.order-id   { font-size: 12px; color: #9a8a7a; margin-bottom: 4px; }
.order-title { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 700; color: #1a0f0a; }
.order-cat   { font-size: 13px; color: #7a6a5a; margin-top: 2px; }

.status-badge { display: inline-block; padding: 5px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; }

.order-body { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.info-block { background: #faf7f2; border-radius: 8px; padding: 14px; }
.info-label { font-size: 11px; font-weight: 600; color: #9a8a7a; letter-spacing: 0.5px; text-transform: uppercase; margin-bottom: 8px; }
.info-line  { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #3d2b1f; margin-bottom: 6px; }
.info-line:last-child { margin-bottom: 0; }

.artisan-msg {
    margin-top: 16px; background: #fffbeb; border: 1px solid #fcd34d;
    border-radius: 10px; padding: 14px 16px;
}
.artisan-msg-label { font-size: 11px; font-weight: 600; color: #92400e; letter-spacing: 0.5px; text-transform: uppercase; margin-bottom: 8px; }
.artisan-msg-text  { font-size: 14px; color: #78350f; line-height: 1.6; font-style: italic; }
.artisan-msg-date  { font-size: 13px; color: #92400e; font-weight: 600; margin-top: 8px; }

.empty-state { text-align: center; padding: 80px 20px; color: #7a6a5a; }
.empty-state .icon { font-size: 56px; margin-bottom: 16px; }
.empty-state h3 { font-family: 'Playfair Display', serif; font-size: 22px; color: #1a0f0a; margin-bottom: 8px; }
.empty-state a { display: inline-block; margin-top: 16px; padding: 12px 24px; background: #8b4513; color: #fff; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500; }

.price-tag { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #1a0f0a; }

@media (max-width: 640px) { .order-body { grid-template-columns: 1fr; } }
</style>
</head>
<body>
<%
    User user   = (User) session.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String flash = (String) session.getAttribute("flash");
    if (flash != null) session.removeAttribute("flash");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <div class="nav-right">
        <a class="nav-link" href="<%= request.getContextPath() %>/ProductController">Catalogue</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/CartController">🛍 Panier</a>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<div class="main">
    <% if (flash != null) { %><div class="flash"><%= flash %></div><% } %>

    <h1 class="page-title">📦 Mes commandes</h1>
    <p class="page-sub">Suivez l'état de vos commandes en temps réel.</p>

    <% if (orders == null || orders.isEmpty()) { %>
        <div class="empty-state">
            <div class="icon">🛒</div>
            <h3>Aucune commande pour le moment</h3>
            <p>Parcourez notre catalogue et passez votre première commande !</p>
            <a href="<%= request.getContextPath() %>/ProductController">Découvrir les produits →</a>
        </div>
    <% } else { for (Order o : orders) { %>
        <div class="order-card">
            <div class="order-header">
                <div>
                    <div class="order-id">Commande #<%= o.getId() %> · <%= o.getCreatedAt() != null ? sdf.format(o.getCreatedAt()) : "—" %></div>
                    <div class="order-title"><%= o.getProductTitle() %></div>
                    <div class="order-cat"><%= o.getProductCategory() %> · Par <%= o.getArtisanName() %></div>
                </div>
                <div>
                    <span class="status-badge" style="color:<%= o.getStatusColor() %>">
                        <%= o.getStatusLabel() %>
                    </span>
                    <div class="price-tag" style="margin-top:8px;text-align:right">
                        <%= String.format("%.2f", o.getTotalPrice()) %> MAD
                    </div>
                </div>
            </div>

            <div class="order-body">
                <!-- Infos livraison -->
                <div class="info-block">
                    <div class="info-label">📍 Livraison</div>
                    <div class="info-line">👤 <%= o.getBuyerName() %></div>
                    <div class="info-line">📞 <%= o.getBuyerPhone() %></div>
                    <div class="info-line">🏠 <%= o.getBuyerAddress() %></div>
                    <div class="info-line">🌆 <%= o.getBuyerCity() %></div>
                </div>
                <!-- Infos artisan -->
                <div class="info-block">
                    <div class="info-label">🎨 Artisan</div>
                    <div class="info-line">👨‍🎨 <%= o.getArtisanName() %></div>
                    <% if (o.getDeliveryDate() != null) { %>
                        <div class="info-line">📅 Livraison estimée : <strong><%= sdf.format(o.getDeliveryDate()) %></strong></div>
                    <% } else { %>
                        <div class="info-line" style="color:#9a8a7a">📅 Date de livraison : en attente de confirmation</div>
                    <% } %>
                </div>
            </div>

            <!-- Message de l'artisan -->
            <% if (o.getArtisanNote() != null && !o.getArtisanNote().isEmpty()) { %>
            <div class="artisan-msg">
                <div class="artisan-msg-label">💬 Message de l'artisan</div>
                <div class="artisan-msg-text">"<%= o.getArtisanNote() %>"</div>
                <% if (o.getDeliveryDate() != null) { %>
                    <div class="artisan-msg-date">Livraison prévue le : <%= sdf.format(o.getDeliveryDate()) %></div>
                <% } %>
            </div>
            <% } %>
        </div>
    <% } } %>
</div>
</body>
</html>
