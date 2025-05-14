<?php
require_once('_include.php');

// Initialize the auth source 
$auth = new \SimpleSAML\Auth\Simple('custom-multiauth');

// Check if this is a SAML-initiated flow
$isSamlInitiated = (
    isset($_REQUEST['SAMLRequest']) || // SP-initiated
    isset($_REQUEST['SAMLResponse']) || // IdP-initiated response
    isset($_REQUEST['spentityid']) // IdP-first flow
);

// Handle logout if requested
if (isset($_GET['logout'])) {
    $auth->logout('/');
    exit;
}

// Require authentication
$auth->requireAuth();

// If authenticated and not SAML-initiated, show claims
if (!$isSamlInitiated) {
    $attributes = $auth->getAttributes();
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>SimpleSAMLPHP Claims</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f5f5f5;
                color: #333;
            }
            h1 {
                color: #2c3e50;
                border-bottom: 2px solid #3498db;
                padding-bottom: 10px;
            }
            .claims-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin: 20px 0;
            }
            .claims-table th, .claims-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            .claims-table th {
                background-color: #3498db;
                color: #fff;
            }
            .claims-table tr:hover {
                background-color: #f1f1f1;
            }
            .logout-link, .ssp-link {
                display: inline-block;
                padding: 10px 20px;
                color: #fff;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s;
                margin-right: 10px;
            }
            .logout-link {
                background-color: #e74c3c;
            }
            .logout-link:hover {
                background-color: #c0392b;
            }
            .ssp-link {
                background-color: #2ecc71;
            }
            .ssp-link:hover {
                background-color: #27ae60;
            }
            .links {
                margin-top: 20px;
            }
            .logo-container {
    display: flex;
    justify-content: center;
    gap: 20px; /* space between logos */
    margin-bottom: 20px;
}

.logo {
    width: 150px;
    height: 150px;
}
        </style>
    </head>
    <body>
    <div class="logo-container">
    <img src="/ssp-fish-gangsta.png" alt="ssp logo" class="logo">
    <!--<img src="/" alt="logo" class="logo"> -->
</div>
        <H1>Hello There!</H1>
        <p> This page is not intended to be visited. I'm guessing you are here by mistake.</p>
        <p> This is a SimpleSAMLPHP endpoint for showing claims. You may have been trying to get to an application and ended up at this page.</p>
        <p> It may have been one of these applications. If it is not. I would return to the application you came from as you are now logged into the single sign on system..
         </p>
         <p> -- Information Technology Team
         </p>
        <div class="links">
            <a href="" class="ssp-link">Link 1</a>
            <a href="" class="ssp-link">Link 2</a>
            <a href="" class="ssp-link">Link 3</a>
            <a href="" class="ssp-link">Link 4</a>
            
        </div>

        <h1>Claims</h1>
        <table class="claims-table">
            <thead>
                <tr>
                    <th>Attribute</th>
                    <th>Value(s)</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($attributes as $key => $values): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($key); ?></td>
                        <td><?php echo htmlspecialchars(implode(', ', $values)); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

    </body>
    </html>
    <?php
    exit;
}
// Random Comment for CI
// For SAML-initiated flows, do nothing (SimpleSAMLphp continues normal flow)
