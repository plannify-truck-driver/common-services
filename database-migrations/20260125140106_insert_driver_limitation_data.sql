-- Migration: Insert driver limitation data
INSERT INTO public."maximum_entity_limits" (pk_maximum_entity_limit_id, entity_type, maximum_limit, fk_created_employee_id, start_at, end_at, created_at) VALUES
(1, 'DRIVER', 1000, 'f18ce7a3-123c-4690-a782-00c3550aa9e0', NOW(), NULL, NOW());