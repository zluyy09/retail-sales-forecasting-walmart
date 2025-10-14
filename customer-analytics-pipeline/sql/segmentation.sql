WITH rfm AS ( SELECT * FROM rfm_view )
SELECT customer_id, r_score, f_score, m_score,
       CASE
         WHEN r_score>=4 AND f_score>=4 AND m_score>=4 THEN 'Champions'
         WHEN r_score>=4 AND f_score>=3 THEN 'Loyal'
         WHEN r_score<=2 AND f_score>=4 THEN 'At Risk (High F)'
         WHEN r_score>=4 AND m_score<=2 THEN 'Promising (Low M)'
         WHEN r_score<=2 AND f_score<=2 AND m_score<=2 THEN 'Hibernating'
         ELSE 'Regulars'
       END AS segment
FROM rfm;
