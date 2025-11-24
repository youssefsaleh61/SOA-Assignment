"""
1- Generate unique order ID and timestamp
2- Validate input data types
3- Switch from dictionary to SQL
"""
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
from http import HTTPStatus

app = Flask(__name__)


### Should be replaced with database connection and a table
ORDER_INCREMENT = 0
TEMP_CUSTOMER_ARRAY = {}

@app.errorhandler(BadRequest)
def handle_bad_request(error):
    """
    Handle bad rqeuests with invalid JSON format to any URL.

    Returns a JSON response with information about the error.
    """
    return jsonify({"error": "Invalid JSON format", "message": str(error)}), HTTPStatus.BAD_REQUEST

@app.route('/api/orders/create', methods=["POST"])
def create_order():
    """
    Handle POST rqeuests to the '/order/create' URL.

    JSON Parameters:
    customer_id: int,
    products: [{'product_id': int, 'quantity': int}],
    total_amount: int

    JSON Response:
    message: str,
    data: int

    Returns a JSON response with the order id.
    """
    global ORDER_INCREMENT
    data = request.get_json()
    order_id = ORDER_INCREMENT

    # Check for missing parameters
    try:
        customer_id = data['customer_id']
        products = []
        for product in data['products']:
            products.append({'product_id': product['product_id'],
                            'quantity': product['quantity']})
        total_amount = data['total_amount']
    except KeyError as ke:
        return jsonify({'error': f'{ke} is missing from the parameters.'}), HTTPStatus.BAD_REQUEST

    ### Should be replaced with insert into table
    ORDER_INCREMENT += 1
    TEMP_CUSTOMER_ARRAY[order_id] = {'customer_id': customer_id,
                                     'products': products,
                                     'total_amount': total_amount}
    
    return jsonify({
        'message': f'Order created successfully',
        'data': order_id
    }), HTTPStatus.OK

@app.route('/api/orders/<int:order_id>')
def get_order(order_id):
    """
    Handle GET requests to the '/orders/<int:order_id>' URL.

    JSON Response:
    data: {customer_id: int,
            products: [{'product_id': int, 'quantity': int}],
            total_amount: int
    }
    

    Returns a JSON response with the order data.
    """
    try:
        ### Should be replaced with select from table
        order_data = TEMP_CUSTOMER_ARRAY[order_id]

    except KeyError as ke:
        return jsonify({'error': f'Order with id {ke} not found'}), HTTPStatus.NOT_FOUND
    
    return jsonify({'data': order_data}), HTTPStatus.OK

if __name__ == '__main__':
    app.run(port=5001, debug=True)