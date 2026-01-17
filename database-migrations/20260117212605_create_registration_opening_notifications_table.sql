-- Migration: Create registration opening notifications table
CREATE TABLE IF NOT EXISTS public."registration_opening_notifications" (
    fk_maximum_entity_limit_id INTEGER NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    notificated_at TIMESTAMP WITH TIME ZONE,
    unsubscribed_at TIMESTAMP WITH TIME ZONE,

    PRIMARY KEY (fk_maximum_entity_limit_id, email),
    CONSTRAINT fk_maximum_entity_limit_id
    FOREIGN KEY (fk_maximum_entity_limit_id)
    REFERENCES maximum_entity_limits(pk_maximum_entity_limit_id)
    ON DELETE CASCADE
);
