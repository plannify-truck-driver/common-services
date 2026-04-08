-- Migration: Insert update data
INSERT INTO public."updates" (pk_update_id, version, description, entity_type, mandatory_completion_date, fk_created_employee_id, created_at) VALUES
(1, '0.1.0', 'Initial update for driver application', 'DRIVER', NOW(), 'f18ce7a3-123c-4690-a782-00c3550aa9e0', NOW());