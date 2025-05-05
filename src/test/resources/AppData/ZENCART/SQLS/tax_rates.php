select r.tax_rates_id, z.geo_zone_id, z.geo_zone_name, tc.tax_class_title, tc.tax_class_id, r.tax_priority, r.tax_rate, r.tax_description, r.date_added, r.last_modified from TAX_CLASS  tc, TAX_RATES r left join GEO_ZONES  z on r.tax_zone_id = z.geo_zone_id where r.tax_class_id 0;

