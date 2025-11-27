from flask import Flask, jsonify, request
from flask_cors import CORS
from db_operations import execute_stored_procedure, DatabaseExecutionError
from werkzeug.exceptions import BadRequest
from http import HTTPStatus

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

conn_str = (
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=localhost;'
            'DATABASE=ecommerce_system;'
            'Trusted_Connection=yes'
           )

@app.errorhandler(BadRequest)
def handle_bad_request(error):
    """
    Handle bad rqeuests with invalid JSON format to any URL.

    Returns a JSON response with information about the error.
    """
    return jsonify({"error": "Invalid JSON format", "message": str(error)}), HTTPStatus.BAD_REQUEST

@app.route('/api/inventory/check/<int:product_id>')
def check_product_availability(product_id):
    try:
        rows = execute_stored_procedure('GetProductAvailabilityById', (product_id,), conn_str)[0]
    except DatabaseExecutionError:
        return jsonify({'error': f'Error executing database operations'}), HTTPStatus.INTERNAL_SERVER_ERROR
    if rows:
        row = rows[0]
        product_name = row[0]
        quantity = row[1]
        return jsonify({'message': f'Product is {'available' if quantity > 0 else 'not available.'}',
                    'data': {'product_name': product_name,'quantity': quantity}}), HTTPStatus.OK
    else:
        return jsonify({'error': f'Product with id {product_id} not found'}), HTTPStatus.NOT_FOUND

@app.route('/api/inventory/update', methods=["PUT"])
def update_inventory():
    data = request.get_json()

    try:
        products = []
        for product in data['products']:
            products.append((product['product_id'], product['quantity']))
    except KeyError as ke:
        return jsonify({'error': f'{ke} is missing from the parameters.'}), HTTPStatus.BAD_REQUEST
    try:
        rows = execute_stored_procedure('UpdateInventory', (products, ), conn_str)[0]
    except DatabaseExecutionError as e:
        print(e)
        return jsonify({'error': f'Error executing database operations'}), HTTPStatus.INTERNAL_SERVER_ERROR
    
    return jsonify({'message': f'Inventory updated successfully'}), 200

if __name__ == '__main__':
    app.run(port=5002, debug=True)