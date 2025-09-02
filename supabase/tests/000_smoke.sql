BEGIN;
  -- pgTAP の配線確認（まずは1件だけのパスするテスト）
  SELECT plan(1);
  SELECT pass('pgTAP wired: migrations applied & DB reachable');
ROLLBACK;
