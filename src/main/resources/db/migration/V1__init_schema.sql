CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE accounts (
                          id BIGSERIAL PRIMARY KEY,
                          user_id BIGINT NOT NULL REFERENCES users(id),
                          currency CHAR(3) NOT NULL,
                          balance NUMERIC(19,4) NOT NULL DEFAULT 0,
                          version BIGINT NOT NULL DEFAULT 0,
                          CHECK (balance >= 0)
);

CREATE TABLE transfers (
                           id BIGSERIAL PRIMARY KEY,
                           idempotency_key VARCHAR(100) UNIQUE NOT NULL,
                           from_account_id BIGINT NOT NULL REFERENCES accounts(id),
                           to_account_id BIGINT NOT NULL REFERENCES accounts(id),
                           amount NUMERIC(19,4) NOT NULL CHECK (amount > 0),
                           created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE ledger_entries (
                                id BIGSERIAL PRIMARY KEY,
                                transfer_id BIGINT NOT NULL REFERENCES transfers(id),
                                account_id BIGINT NOT NULL REFERENCES accounts(id),
                                direction VARCHAR(6) NOT NULL,  -- DEBIT or CREDIT
                                amount NUMERIC(19,4) NOT NULL,
                                created_at TIMESTAMP NOT NULL DEFAULT now()
);