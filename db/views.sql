CREATE VIEW public.vw_monthly_cash_flow AS
 SELECT d.year,
    d.month,
    sum(t.amount) AS net_cash_flow
   FROM (public.transactions t
     JOIN public.dim_date d ON ((d.date_id = t.date_id)))
  GROUP BY d.year, d.month
  ORDER BY d.year, d.month;
CREATE VIEW public.vw_monthly_expenses AS
 SELECT e.entity_name AS department,
    d.year,
    d.month,
    x.expense_category,
    sum(x.amount) AS total_expense
   FROM ((public.expenses x
     JOIN public.dim_entity e ON ((e.entity_id = x.entity_id)))
     JOIN public.dim_date d ON ((d.date_id = x.date_id)))
  GROUP BY e.entity_name, d.year, d.month, x.expense_category
  ORDER BY e.entity_name, d.year, d.month;
CREATE VIEW public.vw_monthly_revenue AS
 SELECT e.entity_name AS customer,
    d.year,
    d.month,
    sum(r.amount) AS revenue
   FROM ((public.revenue r
     JOIN public.dim_entity e ON ((e.entity_id = r.entity_id)))
     JOIN public.dim_date d ON ((d.date_id = r.date_id)))
  GROUP BY e.entity_name, d.year, d.month
  ORDER BY e.entity_name, d.year, d.month;
CREATE VIEW public.vw_quarterly_financials AS
 SELECT e.entity_name AS borrower,
    d.year,
    d.quarter,
    f.statement_type,
    f.line_item,
    sum(f.amount) AS amount
   FROM ((public.financials f
     JOIN public.dim_entity e ON ((e.entity_id = f.entity_id)))
     JOIN public.dim_date d ON ((d.date_id = f.date_id)))
  WHERE (d.is_quarter_end = true)
  GROUP BY e.entity_name, d.year, d.quarter, f.statement_type, f.line_item
  ORDER BY e.entity_name, d.year, d.quarter;
