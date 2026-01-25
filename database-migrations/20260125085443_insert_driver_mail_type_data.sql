-- Migration: Insert driver mail type data
INSERT INTO public."driver_mail_types" (pk_driver_mail_type_id, label, index, is_editable) VALUES
(1, 'ACCOUNT_VERIFICATION', 1, FALSE),
(2, 'PASSWORD_RESET', 2, FALSE),
(3, 'ACCOUNT_CHANGEMENT', 3, FALSE),
(4, 'MONTHLY_REPORTS', 4, TRUE);