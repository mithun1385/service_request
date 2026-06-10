using {serviceRequest as db} from '../db/schema';

service serviceHandler {

    // ─────────────────────────────────────────
    // Customers
    // ─────────────────────────────────────────
    @odata.draft.enabled: true
    entity customers       as projection on db.Customers
        actions {
            action placeOrder(orderDate: Date,
                              status: String) returns String;
        };

    // ─────────────────────────────────────────
    // Products
    // ─────────────────────────────────────────
    entity products        as projection on db.Products
        actions {
            action addStock(quantity: Integer) returns String;
        };

    // ─────────────────────────────────────────
    // Orders
    // ─────────────────────────────────────────
    entity orders          as projection on db.Orders
        actions {
            action approveOrder(status: String) returns String;
        };

    // ─────────────────────────────────────────
    // Order Items
    // ─────────────────────────────────────────
    entity orderItems      as projection on db.OrderItems;

    // ─────────────────────────────────────────
    // Service Requests
    // ─────────────────────────────────────────
  entity serviceRequests as projection on db.ServiceRequests
    actions {
        action closeTicket(status: String);  
    };

entity serviceValueStatus as projection on db.serviceValueStatus; 

}


annotate serviceHandler.customers with @requires: 'admin';
