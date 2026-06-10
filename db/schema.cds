using {
    cuid,
    managed
} from '@sap/cds/common';

namespace serviceRequest;

entity Customers : cuid, managed {
    customerName    : String(250);
    email           : String(100);
    phone           : String(150);
    city            : String(50);
    status          : String(20) default 'ACTIVE';

    orders          : Composition of many Orders
                          on orders.customer = $self;

    serviceRequests : Composition of many ServiceRequests
                          on serviceRequests.customer = $self;
}

entity Products : cuid, managed {
    productName : String(150);
    category    : String(100);
    price       : Decimal(10, 2);
    stock       : Integer;
    status      : String(20) default 'ACTIVE';
}

entity Orders : cuid, managed {
    customer    : Association to Customers;
    orderDate   : Date;
    totalAmount : Decimal(10, 2);
    status      : String(20);

    items       : Composition of many OrderItems
                      on items.order = $self;
}

entity OrderItems : cuid, managed {
    order     : Association to Orders;
    product   : Association to Products;
    quantity  : Integer;
    unitPrice : Decimal(10, 2);
    lineTotal : Decimal(10, 2);
}


entity ServiceRequests : cuid, managed {
    customer   : Association to Customers;
    issue      : String(500);
    priority   : String(20);
    status     : String(20) default 'OPEN';
    assignedTo : String(100);
}

entity serviceValueStatus  {
    key code : String;
}



