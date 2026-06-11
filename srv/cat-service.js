const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { customers, orders, products, serviceRequests } = this.entities;

    // ══════════════════════════════════════════════════
    // Place Order
    // ══════════════════════════════════════════════════
    this.on('placeOrder', 'customers', async (req) => {
        const { orderDate, status } = req.data;
        const { ID } = req.params[0];

        const order = {
            ID         : cds.utils.uuid(),
            customer_ID: ID,
            orderDate  : orderDate,
            status     : status || 'pending',
            totalAmount: 0
        };

        await this.run(INSERT.into(orders).entries(order));
        return `Order placed successfully for customer ${ID}`;
    });

    // ══════════════════════════════════════════════════
    // Approve Order
    // ══════════════════════════════════════════════════
    this.on('approveOrder', 'orders', async (req) => {
        const { ID } = req.params[0];

        await this.run(
            UPDATE(orders)
                .set({ status: 'Approved' })
                .where({ ID: ID })
        );
        return `Order ${ID} approved successfully`;
    });

    // ══════════════════════════════════════════════════
    // Add Stock
    // ══════════════════════════════════════════════════
    this.on('addStock', 'products', async (req) => {
        const { quantity } = req.data;
        const { ID } = req.params[0];

        const product = await this.run(
            SELECT.one.from(products).where({ ID: ID })
        );

        if (!product) return req.error(404, 'Product not found');

        await this.run(
            UPDATE(products)
                .set({ stock: product.stock + quantity })
                .where({ ID: ID })
        );
        return `Stock updated successfully`;
    });

    // ══════════════════════════════════════════════════
    // Close Ticket
    // ══════════════════════════════════════════════════
    this.on('closeTicket', 'serviceRequests', async (req) => {
        const { status } = req.data;
        const { ID } = req.params[0];

        // Step 1: Validate status selected
        if (!status) {
            return req.error(400, 'Please select a status.');
        }

        // Step 2: Fetch current ticket from DB — ID only, no IsActiveEntity
        const ticket = await cds.db.run(
            SELECT.one.from('serviceRequest.ServiceRequests')
                .where({ ID: ID })   // ✅ ID only — IsActiveEntity is not a real DB column
        );


        if (!ticket) {
            return req.error(404, 'Ticket not found.');
        }


        if (
            ticket.status === 'closed'    ||
            ticket.status === 'resolved'  ||
            ticket.status === 'cancelled'
        ) {
            return req.error(422, `Ticket is already "${ticket.status}". Cannot close again.`);
        }

        // Step 5: Update active entity in DB — ID only
        await cds.db.run(
            UPDATE('serviceRequest.ServiceRequests')
                .set({ status: status })
                .where({ ID: ID })   // ✅ ID only
        );

        // Step 6: Also update draft shadow table if draft exists
        await cds.db.run(
            UPDATE('serviceRequest.ServiceRequests_drafts')
                .set({ status: status })
                .where({ ID: ID })
        ).catch(() => {}); // ignore if no draft exists

        // Step 7: Notify success
        req.notify(200, `Ticket closed successfully with status: ${status}`);
    });

});