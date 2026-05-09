<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="ma.ac.esi.moroccocraft.model.Order" %>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MoroccoCraft — Commandes reçues</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f5f0e8; color: #1a0f0a; min-height: 100vh; }

nav {
    background: #1a0f0a; padding: 0 40px;
    display: flex; align-items: center; justify-content: space-between; height: 60px;
    position: sticky; top: 0; z-index: 100;
}
.nav-logo  { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; text-decoration: none; }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link  { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
.nav-link:hover { color: #f4c97a; }
.btn-logout {
    background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.7); padding: 7px 14px; border-radius: 6px;
    font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif;
}

.main { max-width: 960px; margin: 40px auto; padding: 0 20px; }

/* Flash messages */
.flash {
    padding: 14px 18px; border-radius: 10px; margin-bottom: 24px; font-size: 14px;
    display: flex; align-items: center; gap: 10px;
}
.flash-ok    { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
.flash-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

/* En-tête page */
.page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
.page-title  { font-family: 'Playfair Display', serif; font-size: 28px; color: #1a0f0a; }
.page-count  {
    background: #fdf5ec; color: #8b4513; border: 1px solid #f4d5b8;
    padding: 6px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;
}

/* Carte commande */
.order-card {
    background: #fff; border-radius: 16px; border: 1px solid #e8e0d4;
    margin-bottom: 20px; overflow: hidden;
    transition: box-shadow .2s;
}
.order-card:hover { box-shadow: 0 4px 24px rgba(44,24,16,0.08); }

/* Header de la carte */
.order-head {
    display: flex; align-items: center; justify-content: space-between;
    padding: 20px 24px; border-bottom: 1px solid #f0e8dc;
    background: #faf7f2;
}
.order-meta  { }
.order-ref   { font-size: 12px; color: #9a8a7a; margin-bottom: 4px; }
.order-prod  { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 700; color: #1a0f0a; }
.order-cat   { font-size: 13px; color: #7a6a5a; margin-top: 2px; }
.order-right { text-align: right; }
.order-price { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #1a0f0a; }

/* Badge statut */
.status-badge {
    display: inline-block; padding: 5px 14px; border-radius: 20px;
    font-size: 12px; font-weight: 600; margin-bottom: 6px;
}

/* Corps de la carte */
.order-body { padding: 20px 24px; }

/* Infos client en blocs */
.client-grid {
    display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px;
}
.client-field {
    background: #faf7f2; border-radius: 10px; padding: 12px 16px;
    border: 1px solid #f0e8dc;
}
.client-field-label {
    font-size: 11px; font-weight: 600; color: #9a8a7a;
    text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px;
}
.client-field-value { font-size: 14px; color: #1a0f0a; font-weight: 500; }

/* Téléphone mis en avant */
.client-phone-box {
    background: #f0fdf4; border: 1.5px solid #86efac; border-radius: 12px;
    padding: 14px 18px; margin-bottom: 20px;
    display: flex; align-items: center; gap: 12px;
}
.client-phone-label { font-size: 12px; font-weight: 600; color: #166534; margin-bottom: 3px; }
.client-phone-num   { font-size: 20px; font-weight: 700; color: #166534; letter-spacing: 1px; }
.client-phone-hint  { font-size: 12px; color: #4ade80; margin-top: 2px; }

/* Formulaire confirmation artisan */
.confirm-box {
    background: #fffbeb; border: 1.5px solid #fcd34d; border-radius: 12px; padding: 20px;
}
.confirm-box-title {
    font-size: 14px; font-weight: 600; color: #78350f;
    margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
}
.form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px; }
.form-group  { }
.form-label  { display: block; font-size: 12px; font-weight: 600; color: #5a4a3a; margin-bottom: 5px; }

input[type="date"],
textarea {
    width: 100%; padding: 10px 12px;
    border: 1.5px solid #fcd34d; border-radius: 8px;
    font-size: 14px; font-family: 'Inter', sans-serif;
    background: #fff; color: #1a0f0a; outline: none;
    transition: border-color .2s;
}
input[type="date"]:focus,
textarea:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245,158,11,0.1); }
textarea { height: 90px; resize: vertical; }

.btn-confirm {
    padding: 11px 28px; background: #8b4513; color: #fff;
    border: none; border-radius: 8px; font-size: 14px; font-weight: 600;
    font-family: 'Inter', sans-serif; cursor: pointer; transition: all .2s;
}
.btn-confirm:hover { background: #6b3410; box-shadow: 0 4px 14px rgba(139,69,19,0.3); }

/* Boite message déjà confirmé */
.confirmed-box {
    background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 16px 20px;
}
.confirmed-msg  { font-size: 14px; color: #166534; font-style: italic; margin-bottom: 10px; line-height: 1.6; }
.confirmed-date { font-size: 13px; font-weight: 600; color: #166534; }

/* Boutons changement de statut */
.status-btns { display: flex; gap: 10px; margin-top: 14px; flex-wrap: wrap; }
.btn-status  {
    padding: 8px 18px; border: none; border-radius: 8px;
    font-size: 13px; font-weight: 600; font-family: 'Inter', sans-serif;
    cursor: pointer; transition: all .2s;
}
.btn-livraison { background: #dbeafe; color: #1e40af; }
.btn-livraison:hover { background: #bfdbfe; }
.btn-livree    { background: #dcfce7; color: #166534; }
.btn-livree:hover { background: #bbf7d0; }
.btn-annulee   { background: #fee2e2; color: #991b1b; }
.btn-annulee:hover { background: #fecaca; }

/* État vide */
.empty-state {
    text-align: center; padding: 80px 20px;
    background: #fff; border-radius: 16px; border: 1px solid #e8e0d4;
    color: #7a6a5a;
}
.empty-icon { font-size: 56px; margin-bottom: 16px; }
.empty-title { font-family: 'Playfair Display', serif; font-size: 22px; color: #1a0f0a; margin-bottom: 8px; }
.empty-sub   { font-size: 14px; line-height: 1.6; }

@media (max-width: 640px) {
    .client-grid { grid-template-columns: 1fr; }
    .form-grid-2 { grid-template-columns: 1fr; }
    .order-head  { flex-direction: column; gap: 12px; align-items: flex-start; }
}
</style>
</head>
<body>
<%
    User connectedUser = (User) session.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    // Flash messages depuis la session
    String flash      = (String) session.getAttribute("flash");
    String flashError = (String) session.getAttribute("flash_error");
    if (flash      != null) session.removeAttribute("flash");
    if (flashError != null) session.removeAttribute("flash_error");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    int nbOrders = (orders != null) ? orders.size() : 0;
%>

<!-- Navbar -->
<nav>
    <a class="nav-logo" href="<%= request.getContextPath() %>/ProductController">🏺 MoroccoCraft</a>
    <div class="nav-right">
        <a class="nav-link" href="<%= request.getContextPath() %>/ProductController">Catalogue</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/MyProductsController">📦 Mes produits</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/SubmitProductController">+ Ajouter</a>
        <span style="color:rgba(255,255,255,0.6);font-size:14px">
            <%= connectedUser != null ? connectedUser.getName() : "" %>
        </span>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<div class="main">

    <!-- Flash messages -->
    <% if (flash      != null) { %><div class="flash flash-ok">   <%= flash      %></div><% } %>
    <% if (flashError != null) { %><div class="flash flash-error"><%= flashError %></div><% } %>

    <!-- En-tête -->
    <div class="page-header">
        <h1 class="page-title">📬 Commandes reçues</h1>
        <span class="page-count"><%= nbOrders %> commande<%= nbOrders > 1 ? "s" : "" %></span>
    </div>

    <!-- État vide -->
    <% if (orders == null || orders.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <div class="empty-title">Aucune commande pour le moment</div>
            <p class="empty-sub">
                Vos commandes apparaîtront ici dès qu'un client<br>
                passera une commande sur l'un de vos produits.
            </p>
        </div>

    <!-- Liste des commandes -->
    <% } else { for (Order o : orders) { %>

        <div class="order-card">

            <!-- En-tête de la carte -->
            <div class="order-head">
                <div class="order-meta">
                    <div class="order-ref">
                        Commande #<%= o.getId() %>
                        <% if (o.getCreatedAt() != null) { %>
                            &nbsp;·&nbsp; <%= sdf.format(o.getCreatedAt()) %>
                        <% } %>
                    </div>
                    <div class="order-prod"><%= o.getProductTitle() != null ? o.getProductTitle() : "—" %></div>
                    <div class="order-cat"><%= o.getProductCategory() != null ? o.getProductCategory() : "" %></div>
                </div>
                <div class="order-right">
                    <div>
                        <span class="status-badge" style="color:<%= o.getStatusColor() %>">
                            <%= o.getStatusLabel() %>
                        </span>
                    </div>
                    <div class="order-price"><%= String.format("%.2f", o.getTotalPrice()) %> MAD</div>
                </div>
            </div>

            <!-- Corps de la carte -->
            <div class="order-body">

                <!-- Téléphone du client mis en avant -->
                <div class="client-phone-box">
                    <div style="font-size:28px">📞</div>
                    <div>
                        <div class="client-phone-label">Téléphone du client</div>
                        <div class="client-phone-num"><%= o.getBuyerPhone() != null ? o.getBuyerPhone() : "Non renseigné" %></div>
                        <div class="client-phone-hint">Appelez ce numéro pour organiser la livraison</div>
                    </div>
                </div>

                <!-- Infos client en grille -->
                <div class="client-grid">
                    <div class="client-field">
                        <div class="client-field-label">👤 Nom du client</div>
                        <div class="client-field-value"><%= o.getBuyerName() != null ? o.getBuyerName() : "—" %></div>
                    </div>
                    <div class="client-field">
                        <div class="client-field-label">🌆 Ville</div>
                        <div class="client-field-value"><%= o.getBuyerCity() != null ? o.getBuyerCity() : "—" %></div>
                    </div>
                    <div class="client-field" style="grid-column: 1/-1">
                        <div class="client-field-label">🏠 Adresse de livraison</div>
                        <div class="client-field-value"><%= o.getBuyerAddress() != null ? o.getBuyerAddress() : "—" %></div>
                    </div>
                </div>

                <!-- Action selon statut -->
                <% if ("EN_ATTENTE".equals(o.getStatus())) { %>

                    <!-- Formulaire de confirmation -->
                    <div class="confirm-box">
                        <div class="confirm-box-title">
                            📋 Confirmer cette commande et envoyer un message au client
                        </div>
                        <form action="<%= request.getContextPath() %>/OrderController" method="post">
                            <input type="hidden" name="action" value="confirm">
                            <input type="hidden" name="id"     value="<%= o.getId() %>">
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label">📅 Date de livraison estimée *</label>
                                    <input type="date" name="deliveryDate" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">💬 Votre message au client *</label>
                                    <textarea name="note"
                                        placeholder="Ex : Bonjour ! Votre tapis Beni Ourain est en cours de finition. Je vous contacterai 2 jours avant la livraison..."
                                        required></textarea>
                                </div>
                            </div>
                            <button type="submit" class="btn-confirm">
                                ✓ Confirmer et envoyer le message
                            </button>
                        </form>
                    </div>

                <% } else { %>

                    <!-- Message et date déjà envoyés -->
                    <div class="confirmed-box">
                        <% if (o.getArtisanNote() != null && !o.getArtisanNote().isEmpty()) { %>
                            <div class="confirmed-msg">"<%= o.getArtisanNote() %>"</div>
                        <% } %>
                        <% if (o.getDeliveryDate() != null) { %>
                            <div class="confirmed-date">
                                📅 Livraison prévue le : <%= sdf.format(o.getDeliveryDate()) %>
                            </div>
                        <% } %>

                        <!-- Boutons pour faire avancer le statut -->
                        <div class="status-btns">
                            <% if ("CONFIRMEE".equals(o.getStatus())) { %>
                                <form action="<%= request.getContextPath() %>/OrderController" method="post">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="id"     value="<%= o.getId() %>">
                                    <input type="hidden" name="status" value="EN_LIVRAISON">
                                    <button type="submit" class="btn-status btn-livraison">🚚 En livraison</button>
                                </form>
                            <% } %>
                            <% if ("EN_LIVRAISON".equals(o.getStatus())) { %>
                                <form action="<%= request.getContextPath() %>/OrderController" method="post">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="id"     value="<%= o.getId() %>">
                                    <input type="hidden" name="status" value="LIVREE">
                                    <button type="submit" class="btn-status btn-livree">📦 Marquer comme livrée</button>
                                </form>
                            <% } %>
                            <% if (!"LIVREE".equals(o.getStatus()) && !"ANNULEE".equals(o.getStatus())) { %>
                                <form action="<%= request.getContextPath() %>/OrderController" method="post"
                                      onsubmit="return confirm('Annuler cette commande ?')">
                                    <input type="hidden" name="action" value="status">
                                    <input type="hidden" name="id"     value="<%= o.getId() %>">
                                    <input type="hidden" name="status" value="ANNULEE">
                                    <button type="submit" class="btn-status btn-annulee">❌ Annuler</button>
                                </form>
                            <% } %>
                        </div>
                    </div>

                <% } %>
            </div><!-- fin order-body -->
        </div><!-- fin order-card -->

    <% } } %>
</div>
</body>
</html>
