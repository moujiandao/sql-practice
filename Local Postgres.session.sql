

select * from invoices;

select * from invoice_lines;


/*
Part 1: Write a query that shows ALL invoices with:

Invoice ID and vendor name
The invoice header total


The calculated total from line items
The variance (difference between them)
But ONLY show invoices where the variance is greater than $0.01 (either positive or negative)

Part 2: Show me the top 10 worst discrepancies ordered by the absolute value of the variance (biggest problems first).
Part 3: Also flag any invoices that have no line items at all - those are a different kind of problem.
You've got 25 minutes. Talk me through your approach first, then code it up. Ready?"
*/


SELECT invoice_id, vendor_name FROM invoices;

SELECT SUM(invoice_total) FROM invoices

SELECT i.invoice_id, i.vendor_name, i.invoice_total, SUM(il.quantity * il.unit_price) AS invoice_total_calculated,
ABS(i.invoice_total - SUM(il.quantity * il.unit_price)) AS variance FROM invoices i LEFT JOIN invoice_lines il ON i.invoice_id = il.invoice_id 
WHERE ABS(i.invoice_total - SUM(il.quantity * il.unit_price)) >= 0.01 GROUP BY i.invoice_id, i.vendor_name, i.invoice_total ORDER BY i.invoice_id;


SELECT i.invoice_id, i.vendor_name, i.invoice_total, SUM(il.quantity * il.unit_price) AS invoice_total_calculated, ABS(i.invoice_total - SUM(il.quantity * il.unit_price)) AS variance FROM invoices i LEFT JOIN invoice_lines il ON i.invoice_id = il.invoice_id GROUP BY i.invoice_id, i.vendor_name, i.invoice_total HAVING ABS(i.invoice_total - SUM(il.quantity * il.unit_price)) >= 0.01 ORDER BY variance DESC LIMIT 10;


SELECT * FROM invoices i LEFT JOIN invoice_lines il ON i.invoice_id = il.invoice_id;