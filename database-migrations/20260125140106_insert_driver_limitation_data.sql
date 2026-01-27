-- Migration: Insert driver limitation data
INSERT INTO public."maximum_entity_limits" (entity_type, maximum_limit, fk_created_employee_id, start_at, end_at, created_at) VALUES
('DRIVER', 1000, 'f18ce7a3-123c-4690-a782-00c3550aa9e0', NOW(), NULL, NOW());