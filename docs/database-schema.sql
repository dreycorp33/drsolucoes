-- PostgreSQL schema base para ERP SaaS multi-tenant

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(150) NOT NULL,
  legal_name VARCHAR(200),
  cnpj VARCHAR(18),
  email VARCHAR(180),
  phone VARCHAR(30),
  timezone VARCHAR(80) DEFAULT 'America/Sao_Paulo',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(50) NOT NULL,
  permissions JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, name)
);

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  role_id UUID REFERENCES roles(id),
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(180) NOT NULL,
  password_hash TEXT NOT NULL,
  phone VARCHAR(30),
  two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, email)
);

CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  full_name VARCHAR(180) NOT NULL,
  document VARCHAR(20),
  email VARCHAR(180),
  phone VARCHAR(30),
  whatsapp VARCHAR(30),
  zipcode VARCHAR(10),
  street VARCHAR(180),
  number VARCHAR(20),
  district VARCHAR(120),
  city VARCHAR(120),
  state VARCHAR(2),
  complement VARCHAR(120),
  credit_limit NUMERIC(12,2) NOT NULL DEFAULT 0,
  rating SMALLINT DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(120) NOT NULL,
  parent_id UUID REFERENCES categories(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, name)
);

CREATE TABLE suppliers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(180) NOT NULL,
  document VARCHAR(20),
  email VARCHAR(180),
  phone VARCHAR(30),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id UUID REFERENCES categories(id),
  supplier_id UUID REFERENCES suppliers(id),
  name VARCHAR(180) NOT NULL,
  sku VARCHAR(60) NOT NULL,
  barcode VARCHAR(60),
  description TEXT,
  cost_price NUMERIC(12,2) NOT NULL,
  sale_price NUMERIC(12,2) NOT NULL,
  profit_margin NUMERIC(8,2),
  stock_current NUMERIC(12,3) NOT NULL DEFAULT 0,
  stock_minimum NUMERIC(12,3) NOT NULL DEFAULT 0,
  unit VARCHAR(20) NOT NULL DEFAULT 'UN',
  image_url TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  is_composite BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, sku)
);

CREATE TABLE sales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id UUID REFERENCES customers(id),
  cashier_user_id UUID REFERENCES users(id),
  sale_number BIGSERIAL,
  status VARCHAR(30) NOT NULL DEFAULT 'COMPLETED',
  discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  subtotal_amount NUMERIC(12,2) NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  change_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE sale_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  sale_id UUID NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  quantity NUMERIC(12,3) NOT NULL,
  unit_price NUMERIC(12,2) NOT NULL,
  discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_amount NUMERIC(12,2) NOT NULL
);

CREATE TABLE sale_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  sale_id UUID NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
  method VARCHAR(30) NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  paid_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE stock_movements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  movement_type VARCHAR(30) NOT NULL,
  quantity NUMERIC(12,3) NOT NULL,
  reason VARCHAR(120),
  source_module VARCHAR(30) NOT NULL,
  reference_id UUID,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE cash_register_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  opened_by UUID NOT NULL REFERENCES users(id),
  closed_by UUID REFERENCES users(id),
  opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
  closed_at TIMESTAMP,
  opening_amount NUMERIC(12,2) NOT NULL,
  closing_amount NUMERIC(12,2),
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN'
);

CREATE TABLE financial_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  type VARCHAR(20) NOT NULL,
  category VARCHAR(80),
  description TEXT,
  amount NUMERIC(12,2) NOT NULL,
  due_date DATE,
  paid_at TIMESTAMP,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  reference_id UUID,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  action VARCHAR(120) NOT NULL,
  entity VARCHAR(80) NOT NULL,
  entity_id UUID,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  ip_address VARCHAR(64),
  user_agent TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_tenant ON users (tenant_id);
CREATE INDEX idx_customers_tenant ON customers (tenant_id);
CREATE INDEX idx_products_tenant ON products (tenant_id);
CREATE INDEX idx_products_tenant_barcode ON products (tenant_id, barcode);
CREATE INDEX idx_sales_tenant_created ON sales (tenant_id, created_at DESC);
CREATE INDEX idx_sale_items_tenant_sale ON sale_items (tenant_id, sale_id);
CREATE INDEX idx_stock_movements_tenant_product ON stock_movements (tenant_id, product_id, created_at DESC);
CREATE INDEX idx_financial_entries_tenant_due ON financial_entries (tenant_id, due_date);
CREATE INDEX idx_audit_logs_tenant_created ON audit_logs (tenant_id, created_at DESC);
