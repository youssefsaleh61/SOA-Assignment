<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Check</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .header h1 {
            font-size: 28px;
        }
        
        .nav {
            background-color: #45a049;
            padding: 10px 0;
        }
        
        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            gap: 20px;
        }
        
        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        .nav a:hover {
            background-color: #3d8b40;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        h2 {
            color: #333;
            margin-top: 30px;
            margin-bottom: 15px;
        }
        
        .input-group {
            margin: 15px 0;
        }
        
        input {
            padding: 8px;
            margin-right: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        button {
            padding: 8px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #45a049;
        }
        
        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            display: none;
        }
        
        .result.success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            display: block;
        }
        
        .result.error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            display: block;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .status-200 {
            background-color: #28a745;
            color: white;
        }
        
        .status-error {
            background-color: #dc3545;
            color: white;
        }
        
        .data-field {
            margin: 8px 0;
            padding: 8px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 3px;
        }
        
        .data-label {
            font-weight: bold;
            margin-right: 5px;
        }
        
        hr {
            margin: 30px 0;
            border: none;
            border-top: 2px solid #ddd;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-content">
        <h1>🛒 E-Commerce System</h1>
    </div>
</div>

<div class="nav">
    <div class="nav-content">
        <a href="index.jsp">Product Catalog</a>
        <a href="InventoryService.jsp">Inventory Management</a>
        <a href="OrderService.jsp">Order Management</a>
    </div>
</div>

<div class="container">
    <h2>Check Product Availability</h2>

    <div class="input-group">
        <input type="number" id="productId" placeholder="Enter product ID" />
        <button onclick="checkProduct()">Check</button>
    </div>

    <div id="checkResult" class="result"></div>

    <hr />

    <h2>Update Inventory</h2>

    <div class="input-group">
        <input type="number" id="updProductId" placeholder="Product ID" />
        <input type="number" id="updQuantity" placeholder="Quantity" />
        <button onclick="updateInventory()">Update</button>
    </div>

    <div id="updateResult" class="result"></div>
</div>

<script>
function checkProduct() {
    const productId = document.getElementById("productId").value;

    if (!productId) {
        alert("Please enter a product ID");
        return;
    }

    // Call your Flask endpoint
    fetch("http://localhost:5002/api/inventory/check/" + productId)
        .then(response => {
            console.log("Response status:", response.status);
            return response.json().then(data => {
                console.log("Response data:", data);
                return { status: response.status, body: data };
            });
        })
        .then(res => {
            const resultDiv = document.getElementById("checkResult");
            const isSuccess = res.status === 200;
            
            resultDiv.className = isSuccess ? "result success" : "result error";
            
            let html = '<span class="status-badge status-' + (isSuccess ? '200' : 'error') + '">Status: ' + res.status + '</span>';
            
            if (isSuccess && res.body.data) {
                html += '<div class="data-field">' +
                    '<span class="data-label">Message:</span>' + (res.body.message || 'N/A') +
                    '</div>' +
                    '<div class="data-field">' +
                    '<span class="data-label">Product Name:</span>' + (res.body.data.product_name || 'N/A') +
                    '</div>' +
                    '<div class="data-field">' +
                    '<span class="data-label">Quantity:</span>' + (res.body.data.quantity !== undefined ? res.body.data.quantity : 'N/A') +
                    '</div>';
            } else {
                html += '<div class="data-field">' + (res.body.error || res.body.message || 'Unknown error') + '</div>';
            }
            
            resultDiv.innerHTML = html;
        })
        .catch(err => {
            console.error("Fetch error:", err);
            const resultDiv = document.getElementById("checkResult");
            resultDiv.className = "result error";
            resultDiv.innerHTML = '<span class="status-badge status-error">Error</span><div class="data-field">Error calling Flask API. Check console for details.</div>';
        });
}

function updateInventory() {
    const productId = document.getElementById("updProductId").value;
    const quantity = document.getElementById("updQuantity").value;

    if (!productId || !quantity) {
        alert("Please enter both product ID and quantity");
        return;
    }

    const body = {
        products: [
            {
                product_id: parseInt(productId, 10),
                quantity: parseInt(quantity, 10)
            }
        ]
    };

    // Call Flask PUT /api/inventory/update
    fetch("http://localhost:5002/api/inventory/update", {
        method: "PUT",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
    })
        .then(response => response.json().then(data => ({ status: response.status, body: data })))
        .then(res => {
            const resultDiv = document.getElementById("updateResult");
            const isSuccess = res.status === 200;
            
            resultDiv.className = isSuccess ? "result success" : "result error";
            
            let html = '<span class="status-badge status-' + (isSuccess ? '200' : 'error') + '">Status: ' + res.status + '</span>';
            html += '<div class="data-field"><span class="data-label">Message:</span>' + (res.body.message || res.body.error) + '</div>';
            
            resultDiv.innerHTML = html;
        })
        .catch(err => {
            console.error(err);
            const resultDiv = document.getElementById("updateResult");
            resultDiv.className = "result error";
            resultDiv.innerHTML = '<span class="status-badge status-error">Error</span><div class="data-field">Error calling Flask API</div>';
        });
}
</script>

</body>
</html>
