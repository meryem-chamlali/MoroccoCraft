<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="ma.ac.esi.moroccocraft.model.Product" %>
<%@ page import="ma.ac.esi.moroccocraft.model.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoroccoCraft — Administration</title>
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
        .nav-logo { font-family: 'Playfair Display', serif; color: #f4c97a; font-size: 20px; font-weight: 700; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-badge {
            background: #8b4513;
            color: #fff;
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 1px;
            padding: 4px 10px;
            border-radius: 12px;
            text-transform: uppercase;
        }
        .btn-logout {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.7);
            padding: 7px 16px;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.15); color: #fff; }

        .main { max-width: 1100px; margin: 40px auto; padding: 0 20px; }

        /* Stats rapides */
        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #e8e0d4;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .stat-icon { font-size: 28px; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 32px; color: #1a0f0a; font-weight: 700; }
        .stat-label { font-size: 13px; color: #7a6a5a; }

        /* Sections */
        .section { margin-bottom: 48px; }
        .section-header {
            display: flex;
            align-items: baseline;
            gap: 12px;
            margin-bottom: 20px;
        }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            color: #1a0f0a;
        }
        .badge-count {
            background: #fdf5ec;
            color: #8b4513;
            font-size: 12px;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 12px;
            border: 1px solid #f4d5b8;
        }

        /* Table */
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; border: 1px solid #e8e0d4; }
        thead { background: #f5f0e8; }
        th {
            padding: 12px 16px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #5a4a3a;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            border-bottom: 1px solid #e8e0d4;
        }
        td {
            padding: 14px 16px;
            font-size: 14px;
            color: #1a0f0a;
            border-bottom: 1px solid #f0e8dc;
            vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #faf7f2; }

        .product-title { font-weight: 500; }
        .product-artisan { font-size: 13px; color: #7a6a5a; }

        .cat-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            background: #f5f0e8;
            color: #5a4a3a;
        }

        /* Boutons d'action */
        .action-form { display: inline; }
        .btn-approve, .btn-reject, .btn-activate, .btn-ban {
            padding: 7px 14px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all .2s;
        }
        .btn-approve, .btn-activate {
            background: #dcfce7;
            color: #166534;
        }
        .btn-approve:hover, .btn-activate:hover { background: #bbf7d0; }
        .btn-reject, .btn-ban {
            background: #fee2e2;
            color: #991b1b;
            margin-left: 6px;
        }
        .btn-reject:hover, .btn-ban:hover { background: #fecaca; }

        .empty-row td { text-align: center; color: #9a8a7a; padding: 32px; font-size: 14px; }

        .price { font-weight: 600; color: #1a0f0a; }
    </style>
</head>
<body>
<%
    User admin = (User) session.getAttribute("user");
    List<Product> pendingProducts = (List<Product>) request.getAttribute("pendingProducts");
    List<User>    pendingArtisans = (List<User>)    request.getAttribute("pendingArtisans");
    int nbProd = pendingProducts != null ? pendingProducts.size() : 0;
    int nbArt  = pendingArtisans != null ? pendingArtisans.size() : 0;
%>

<nav>
    <span class="nav-logo">🏺 MoroccoCraft</span>
    <div class="nav-right">
        <span class="nav-badge">⚙ Admin</span>
        <span style="color:rgba(255,255,255,0.6);font-size:14px"><%= admin != null ? admin.getName() : "" %></span>
        <form action="<%= request.getContextPath() %>/LogoutController" method="post" style="margin:0">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>
</nav>

<div class="main">

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon">📦</div>
            <div>
                <div class="stat-num"><%= nbProd %></div>
                <div class="stat-label">Produits en attente</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🎨</div>
            <div>
                <div class="stat-num"><%= nbArt %></div>
                <div class="stat-label">Artisans en attente</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div>
                <div class="stat-num"><%= nbProd + nbArt %></div>
                <div class="stat-label">Actions requises</div>
            </div>
        </div>
    </div>

    <!-- Produits en attente -->
    <div class="section">
        <div class="section-header">
            <h2 class="section-title">Produits en attente de validation</h2>
            <span class="badge-count"><%= nbProd %></span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Produit</th>
                    <th>Catégorie</th>
                    <th>Prix</th>
                    <th>Artisan</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% if (nbProd == 0) { %>
                <tr class="empty-row"><td colspan="5">✅ Aucun produit en attente de validation.</td></tr>
            <% } else { for (Product p : pendingProducts) { %>
                <tr>
                    <td>
                        <div class="product-title"><%= p.getTitle() %></div>
                        <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                            <div class="product-artisan">
                                <%= p.getDescription().length() > 60
                                    ? p.getDescription().substring(0, 60) + "..."
                                    : p.getDescription() %>
                            </div>
                        <% } %>
                    </td>
                    <td><span class="cat-badge"><%= p.getCategory() %></span></td>
                    <td class="price"><%= String.format("%.2f", p.getPrice()) %> MAD</td>
                    <td><%= p.getArtisanName() %></td>
                    <td>
                        <form class="action-form"
                              action="<%= request.getContextPath() %>/AdminController" method="post">
                            <input type="hidden" name="actionType" value="product">
                            <input type="hidden" name="id"         value="<%= p.getId() %>">
                            <input type="hidden" name="action"     value="approve">
                            <button type="submit" class="btn-approve">✓ Approuver</button>
                        </form>
                        <form class="action-form"
                              action="<%= request.getContextPath() %>/AdminController" method="post">
                            <input type="hidden" name="actionType" value="product">
                            <input type="hidden" name="id"         value="<%= p.getId() %>">
                            <input type="hidden" name="action"     value="reject">
                            <button type="submit" class="btn-reject">✕ Rejeter</button>
                        </form>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>

    <!-- Artisans en attente -->
    <div class="section">
        <div class="section-header">
            <h2 class="section-title">Artisans en attente d'activation</h2>
            <span class="badge-count"><%= nbArt %></span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Artisan</th>
                    <th>Email</th>
                    <th>Ville</th>
                    <th>Bio</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% if (nbArt == 0) { %>
                <tr class="empty-row"><td colspan="5">✅ Aucun artisan en attente d'activation.</td></tr>
            <% } else { for (User u : pendingArtisans) { %>
                <tr>
                    <td><strong><%= u.getName() %></strong></td>
                    <td style="color:#7a6a5a;font-size:13px"><%= u.getEmail() %></td>
                    <td><%= u.getCity() != null ? u.getCity() : "—" %></td>
                    <td style="font-size:13px;color:#5a4a3a;max-width:220px">
                        <%= u.getBio() != null && u.getBio().length() > 50
                            ? u.getBio().substring(0, 50) + "..."
                            : (u.getBio() != null ? u.getBio() : "—") %>
                    </td>
                    <td>
                        <form class="action-form"
                              action="<%= request.getContextPath() %>/AdminController" method="post">
                            <input type="hidden" name="actionType" value="artisan">
                            <input type="hidden" name="id"         value="<%= u.getId() %>">
                            <input type="hidden" name="action"     value="activate">
                            <button type="submit" class="btn-activate">✓ Activer</button>
                        </form>
                        <form class="action-form"
                              action="<%= request.getContextPath() %>/AdminController" method="post">
                            <input type="hidden" name="actionType" value="artisan">
                            <input type="hidden" name="id"         value="<%= u.getId() %>">
                            <input type="hidden" name="action"     value="ban">
                            <button type="submit" class="btn-ban">✕ Refuser</button>
                        </form>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
