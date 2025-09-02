drop extension if exists "pg_net";


  create table "public"."audit_events" (
    "id" bigint generated always as identity not null,
    "occurred_at" timestamp with time zone not null default now(),
    "actor_user_id" uuid,
    "entity" text not null,
    "entity_id" uuid not null,
    "action" text not null,
    "details" jsonb
      );



  create table "public"."daily_reactions" (
    "id" uuid not null default gen_random_uuid(),
    "target_user_id" uuid not null,
    "reactor_user_id" uuid not null,
    "target_date" date not null,
    "reaction_type" character varying(20) not null default 'thumbs_up'::character varying,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone,
    "deleted_at" timestamp with time zone
      );



  create table "public"."habit_records" (
    "id" uuid not null default gen_random_uuid(),
    "habit_id" uuid not null,
    "user_id" uuid not null,
    "record_date" date not null,
    "status" character varying(20) not null,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone,
    "deleted_at" timestamp with time zone
      );



  create table "public"."habit_tags" (
    "habit_id" uuid not null,
    "tag_id" uuid not null
      );



  create table "public"."habits" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "title" character varying(100) not null,
    "frequency_type" character varying(20) not null,
    "current_streak" integer default 0,
    "total_completed" integer default 0,
    "last_completed_date" date,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "deleted_at" timestamp with time zone,
    "frequency_data" jsonb default '[]'::jsonb,
    "status" text not null default 'active'::text
      );



  create table "public"."tags" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null
      );



  create table "public"."user_stats" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "current_record_streak" integer default 0,
    "total_record_days" integer default 0,
    "last_record_date" date,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "deleted_at" timestamp with time zone
      );



  create table "public"."users" (
    "id" uuid not null default gen_random_uuid(),
    "nickname" character varying(50) not null,
    "password_hash" character varying(255) not null,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "deleted_at" timestamp with time zone,
    "external_provider" text,
    "external_subject" text
      );


CREATE UNIQUE INDEX audit_events_pkey ON public.audit_events USING btree (id);

CREATE UNIQUE INDEX daily_reactions_pkey ON public.daily_reactions USING btree (id);

CREATE UNIQUE INDEX daily_reactions_target_user_id_reactor_user_id_target_date_key ON public.daily_reactions USING btree (target_user_id, reactor_user_id, target_date);

CREATE UNIQUE INDEX habit_records_habit_id_record_date_key ON public.habit_records USING btree (habit_id, record_date);

CREATE UNIQUE INDEX habit_records_pkey ON public.habit_records USING btree (id);

CREATE UNIQUE INDEX habit_tags_pkey ON public.habit_tags USING btree (habit_id, tag_id);

CREATE UNIQUE INDEX habits_pkey ON public.habits USING btree (id);

CREATE INDEX idx_audit_events_actor ON public.audit_events USING btree (actor_user_id);

CREATE INDEX idx_audit_events_entity ON public.audit_events USING btree (entity, entity_id);

CREATE INDEX idx_daily_reactions_date ON public.daily_reactions USING btree (target_date DESC);

CREATE INDEX idx_daily_reactions_reactor_user_date ON public.daily_reactions USING btree (reactor_user_id, target_date);

CREATE INDEX idx_daily_reactions_target ON public.daily_reactions USING btree (target_user_id, target_date);

CREATE INDEX idx_daily_reactions_target_user_date ON public.daily_reactions USING btree (target_user_id, target_date);

CREATE INDEX idx_habit_records_date ON public.habit_records USING btree (record_date);

CREATE INDEX idx_habit_records_date_desc ON public.habit_records USING btree (record_date DESC);

CREATE INDEX idx_habit_records_habit ON public.habit_records USING btree (habit_id);

CREATE INDEX idx_habit_records_habit_date ON public.habit_records USING btree (habit_id, record_date DESC);

CREATE INDEX idx_habit_records_user ON public.habit_records USING btree (user_id);

CREATE INDEX idx_habit_records_user_date ON public.habit_records USING btree (user_id, record_date DESC);

CREATE INDEX idx_habit_records_user_id ON public.habit_records USING btree (user_id);

CREATE INDEX idx_habits_active ON public.habits USING btree (user_id, deleted_at);

CREATE INDEX idx_habits_frequency_data ON public.habits USING gin (frequency_data);

CREATE INDEX idx_habits_status ON public.habits USING btree (status);

CREATE INDEX idx_habits_user ON public.habits USING btree (user_id);

CREATE INDEX idx_habits_user_active ON public.habits USING btree (user_id) WHERE (deleted_at IS NULL);

CREATE INDEX idx_user_stats_user ON public.user_stats USING btree (user_id);

CREATE INDEX idx_user_stats_user_id ON public.user_stats USING btree (user_id);

CREATE INDEX idx_users_active ON public.users USING btree (id) WHERE (deleted_at IS NULL);

CREATE INDEX idx_users_nickname ON public.users USING btree (nickname) WHERE (deleted_at IS NULL);

CREATE UNIQUE INDEX tags_name_key ON public.tags USING btree (name);

CREATE UNIQUE INDEX tags_pkey ON public.tags USING btree (id);

CREATE UNIQUE INDEX uq_habit_records_per_day ON public.habit_records USING btree (habit_id, record_date);

CREATE UNIQUE INDEX uq_users_provider_subject ON public.users USING btree (external_provider, external_subject);

CREATE UNIQUE INDEX user_stats_pkey ON public.user_stats USING btree (id);

CREATE UNIQUE INDEX user_stats_user_id_key ON public.user_stats USING btree (user_id);

CREATE UNIQUE INDEX users_nickname_key ON public.users USING btree (nickname);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."audit_events" add constraint "audit_events_pkey" PRIMARY KEY using index "audit_events_pkey";

alter table "public"."daily_reactions" add constraint "daily_reactions_pkey" PRIMARY KEY using index "daily_reactions_pkey";

alter table "public"."habit_records" add constraint "habit_records_pkey" PRIMARY KEY using index "habit_records_pkey";

alter table "public"."habit_tags" add constraint "habit_tags_pkey" PRIMARY KEY using index "habit_tags_pkey";

alter table "public"."habits" add constraint "habits_pkey" PRIMARY KEY using index "habits_pkey";

alter table "public"."tags" add constraint "tags_pkey" PRIMARY KEY using index "tags_pkey";

alter table "public"."user_stats" add constraint "user_stats_pkey" PRIMARY KEY using index "user_stats_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."daily_reactions" add constraint "daily_reactions_check" CHECK ((target_user_id <> reactor_user_id)) not valid;

alter table "public"."daily_reactions" validate constraint "daily_reactions_check";

alter table "public"."daily_reactions" add constraint "daily_reactions_reactor_user_id_fkey" FOREIGN KEY (reactor_user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."daily_reactions" validate constraint "daily_reactions_reactor_user_id_fkey";

alter table "public"."daily_reactions" add constraint "daily_reactions_target_user_id_fkey" FOREIGN KEY (target_user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."daily_reactions" validate constraint "daily_reactions_target_user_id_fkey";

alter table "public"."daily_reactions" add constraint "daily_reactions_target_user_id_reactor_user_id_target_date_key" UNIQUE using index "daily_reactions_target_user_id_reactor_user_id_target_date_key";

alter table "public"."habit_records" add constraint "habit_records_habit_id_fkey" FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE not valid;

alter table "public"."habit_records" validate constraint "habit_records_habit_id_fkey";

alter table "public"."habit_records" add constraint "habit_records_habit_id_record_date_key" UNIQUE using index "habit_records_habit_id_record_date_key";

alter table "public"."habit_records" add constraint "habit_records_status_check" CHECK (((status)::text = ANY ((ARRAY['completed'::character varying, 'not_completed'::character varying])::text[]))) not valid;

alter table "public"."habit_records" validate constraint "habit_records_status_check";

alter table "public"."habit_records" add constraint "habit_records_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."habit_records" validate constraint "habit_records_user_id_fkey";

alter table "public"."habit_records" add constraint "uq_habit_records_per_day" UNIQUE using index "uq_habit_records_per_day";

alter table "public"."habit_tags" add constraint "habit_tags_habit_id_fkey" FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE not valid;

alter table "public"."habit_tags" validate constraint "habit_tags_habit_id_fkey";

alter table "public"."habit_tags" add constraint "habit_tags_tag_id_fkey" FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE not valid;

alter table "public"."habit_tags" validate constraint "habit_tags_tag_id_fkey";

alter table "public"."habits" add constraint "habits_frequency_type_check" CHECK (((frequency_type)::text = ANY ((ARRAY['daily'::character varying, 'weekly'::character varying])::text[]))) not valid;

alter table "public"."habits" validate constraint "habits_frequency_type_check";

alter table "public"."habits" add constraint "habits_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text]))) not valid;

alter table "public"."habits" validate constraint "habits_status_check";

alter table "public"."habits" add constraint "habits_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."habits" validate constraint "habits_user_id_fkey";

alter table "public"."tags" add constraint "tags_name_key" UNIQUE using index "tags_name_key";

alter table "public"."user_stats" add constraint "user_stats_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."user_stats" validate constraint "user_stats_user_id_fkey";

alter table "public"."user_stats" add constraint "user_stats_user_id_key" UNIQUE using index "user_stats_user_id_key";

alter table "public"."users" add constraint "users_nickname_key" UNIQUE using index "users_nickname_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.auto_assign_tag(habit_title text, habit_description text DEFAULT ''::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    search_text TEXT;
    matched_tag_id UUID;
    other_tag_id UUID;
BEGIN
    -- 検索用テキスト作成（小文字化）
    search_text := LOWER(habit_title || ' ' || COALESCE(habit_description, ''));
    
    -- キーワードマッチングでタグ検索
    SELECT DISTINCT tk.tag_id INTO matched_tag_id
    FROM tag_keywords tk
    WHERE POSITION(LOWER(tk.keyword) IN search_text) > 0
    LIMIT 1;
    
    -- マッチしなかった場合は「その他」タグ
    IF matched_tag_id IS NULL THEN
        SELECT id INTO other_tag_id
        FROM habit_tags 
        WHERE name_en = 'other'
        LIMIT 1;
        RETURN other_tag_id;
    END IF;
    
    RETURN matched_tag_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.update_habit_stats()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    total_count INTEGER;
    last_date DATE;
    streak_count INTEGER;
BEGIN
    -- 新規レコードの場合、または完了ステータスが変更された場合のみ処理
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.status != NEW.status) THEN
        
        -- 総達成回数を計算
        SELECT COUNT(*) INTO total_count
        FROM habit_records 
        WHERE habit_id = NEW.habit_id AND status = 'completed';
        
        -- 最新の完了日を取得
        SELECT MAX(record_date) INTO last_date
        FROM habit_records 
        WHERE habit_id = NEW.habit_id AND status = 'completed';
        
        -- 現在の連続記録を計算（簡略版）
        IF NEW.status = 'completed' THEN
            -- 今日から過去に向かって連続する完了日数をカウント
            WITH RECURSIVE streak_calc AS (
                -- 今日の記録から開始
                SELECT record_date, 1 as streak_days
                FROM habit_records 
                WHERE habit_id = NEW.habit_id 
                  AND record_date = NEW.record_date 
                  AND status = 'completed'
                
                UNION ALL
                
                -- 前日の完了記録があれば連続記録を増やす
                SELECT hr.record_date, sc.streak_days + 1
                FROM habit_records hr
                JOIN streak_calc sc ON hr.record_date = sc.record_date - INTERVAL '1 day'
                WHERE hr.habit_id = NEW.habit_id 
                  AND hr.status = 'completed'
            )
            SELECT COALESCE(MAX(streak_days), 1) INTO streak_count FROM streak_calc;
        ELSE
            -- 未完了の場合は連続記録をリセット
            streak_count := 0;
        END IF;
        
        -- habitsテーブルの統計を更新
        UPDATE habits SET 
            current_streak = COALESCE(streak_count, 0),
            total_completed = COALESCE(total_count, 0),
            last_completed_date = last_date,
            updated_at = NOW()
        WHERE id = NEW.habit_id;
        
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_stats()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_record RECORD;
    record_streak INTEGER;
    total_days INTEGER;
    last_date DATE;
BEGIN
    -- 新規レコードまたはステータス変更の場合のみ処理
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.status != NEW.status) THEN
        
        -- そのユーザーの記録統計を計算
        
        -- 総記録日数を計算（そのユーザーが記録を入力した日数）
        SELECT COUNT(DISTINCT record_date) INTO total_days
        FROM habit_records 
        WHERE user_id = NEW.user_id;
        
        -- 最後に記録した日を取得
        SELECT MAX(record_date) INTO last_date
        FROM habit_records 
        WHERE user_id = NEW.user_id;
        
        -- 現在の連続記録日数を計算（簡略版）
        WITH RECURSIVE streak_calc AS (
            -- 最新の記録日から開始
            SELECT record_date, 1 as streak_days
            FROM (
                SELECT DISTINCT record_date
                FROM habit_records 
                WHERE user_id = NEW.user_id
                ORDER BY record_date DESC
                LIMIT 1
            ) latest
            
            UNION ALL
            
            -- 前日に記録があれば連続記録を増やす
            SELECT hr.record_date, sc.streak_days + 1
            FROM (
                SELECT DISTINCT record_date
                FROM habit_records
                WHERE user_id = NEW.user_id
            ) hr
            JOIN streak_calc sc ON hr.record_date = sc.record_date - INTERVAL '1 day'
        )
        SELECT COALESCE(MAX(streak_days), 0) INTO record_streak FROM streak_calc;
        
        -- user_statsテーブルを更新または挿入
        INSERT INTO user_stats (user_id, current_record_streak, total_record_days, last_record_date, updated_at)
        VALUES (NEW.user_id, record_streak, total_days, last_date, NOW())
        ON CONFLICT (user_id) 
        DO UPDATE SET 
            current_record_streak = record_streak,
            total_record_days = total_days,
            last_record_date = last_date,
            updated_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$function$
;

grant delete on table "public"."audit_events" to "anon";

grant insert on table "public"."audit_events" to "anon";

grant references on table "public"."audit_events" to "anon";

grant select on table "public"."audit_events" to "anon";

grant trigger on table "public"."audit_events" to "anon";

grant truncate on table "public"."audit_events" to "anon";

grant update on table "public"."audit_events" to "anon";

grant delete on table "public"."audit_events" to "authenticated";

grant insert on table "public"."audit_events" to "authenticated";

grant references on table "public"."audit_events" to "authenticated";

grant select on table "public"."audit_events" to "authenticated";

grant trigger on table "public"."audit_events" to "authenticated";

grant truncate on table "public"."audit_events" to "authenticated";

grant update on table "public"."audit_events" to "authenticated";

grant delete on table "public"."audit_events" to "service_role";

grant insert on table "public"."audit_events" to "service_role";

grant references on table "public"."audit_events" to "service_role";

grant select on table "public"."audit_events" to "service_role";

grant trigger on table "public"."audit_events" to "service_role";

grant truncate on table "public"."audit_events" to "service_role";

grant update on table "public"."audit_events" to "service_role";

grant delete on table "public"."daily_reactions" to "anon";

grant insert on table "public"."daily_reactions" to "anon";

grant references on table "public"."daily_reactions" to "anon";

grant select on table "public"."daily_reactions" to "anon";

grant trigger on table "public"."daily_reactions" to "anon";

grant truncate on table "public"."daily_reactions" to "anon";

grant update on table "public"."daily_reactions" to "anon";

grant delete on table "public"."daily_reactions" to "authenticated";

grant insert on table "public"."daily_reactions" to "authenticated";

grant references on table "public"."daily_reactions" to "authenticated";

grant select on table "public"."daily_reactions" to "authenticated";

grant trigger on table "public"."daily_reactions" to "authenticated";

grant truncate on table "public"."daily_reactions" to "authenticated";

grant update on table "public"."daily_reactions" to "authenticated";

grant delete on table "public"."daily_reactions" to "service_role";

grant insert on table "public"."daily_reactions" to "service_role";

grant references on table "public"."daily_reactions" to "service_role";

grant select on table "public"."daily_reactions" to "service_role";

grant trigger on table "public"."daily_reactions" to "service_role";

grant truncate on table "public"."daily_reactions" to "service_role";

grant update on table "public"."daily_reactions" to "service_role";

grant delete on table "public"."habit_records" to "anon";

grant insert on table "public"."habit_records" to "anon";

grant references on table "public"."habit_records" to "anon";

grant select on table "public"."habit_records" to "anon";

grant trigger on table "public"."habit_records" to "anon";

grant truncate on table "public"."habit_records" to "anon";

grant update on table "public"."habit_records" to "anon";

grant delete on table "public"."habit_records" to "authenticated";

grant insert on table "public"."habit_records" to "authenticated";

grant references on table "public"."habit_records" to "authenticated";

grant select on table "public"."habit_records" to "authenticated";

grant trigger on table "public"."habit_records" to "authenticated";

grant truncate on table "public"."habit_records" to "authenticated";

grant update on table "public"."habit_records" to "authenticated";

grant delete on table "public"."habit_records" to "service_role";

grant insert on table "public"."habit_records" to "service_role";

grant references on table "public"."habit_records" to "service_role";

grant select on table "public"."habit_records" to "service_role";

grant trigger on table "public"."habit_records" to "service_role";

grant truncate on table "public"."habit_records" to "service_role";

grant update on table "public"."habit_records" to "service_role";

grant delete on table "public"."habit_tags" to "anon";

grant insert on table "public"."habit_tags" to "anon";

grant references on table "public"."habit_tags" to "anon";

grant select on table "public"."habit_tags" to "anon";

grant trigger on table "public"."habit_tags" to "anon";

grant truncate on table "public"."habit_tags" to "anon";

grant update on table "public"."habit_tags" to "anon";

grant delete on table "public"."habit_tags" to "authenticated";

grant insert on table "public"."habit_tags" to "authenticated";

grant references on table "public"."habit_tags" to "authenticated";

grant select on table "public"."habit_tags" to "authenticated";

grant trigger on table "public"."habit_tags" to "authenticated";

grant truncate on table "public"."habit_tags" to "authenticated";

grant update on table "public"."habit_tags" to "authenticated";

grant delete on table "public"."habit_tags" to "service_role";

grant insert on table "public"."habit_tags" to "service_role";

grant references on table "public"."habit_tags" to "service_role";

grant select on table "public"."habit_tags" to "service_role";

grant trigger on table "public"."habit_tags" to "service_role";

grant truncate on table "public"."habit_tags" to "service_role";

grant update on table "public"."habit_tags" to "service_role";

grant delete on table "public"."habits" to "anon";

grant insert on table "public"."habits" to "anon";

grant references on table "public"."habits" to "anon";

grant select on table "public"."habits" to "anon";

grant trigger on table "public"."habits" to "anon";

grant truncate on table "public"."habits" to "anon";

grant update on table "public"."habits" to "anon";

grant delete on table "public"."habits" to "authenticated";

grant insert on table "public"."habits" to "authenticated";

grant references on table "public"."habits" to "authenticated";

grant select on table "public"."habits" to "authenticated";

grant trigger on table "public"."habits" to "authenticated";

grant truncate on table "public"."habits" to "authenticated";

grant update on table "public"."habits" to "authenticated";

grant delete on table "public"."habits" to "service_role";

grant insert on table "public"."habits" to "service_role";

grant references on table "public"."habits" to "service_role";

grant select on table "public"."habits" to "service_role";

grant trigger on table "public"."habits" to "service_role";

grant truncate on table "public"."habits" to "service_role";

grant update on table "public"."habits" to "service_role";

grant delete on table "public"."tags" to "anon";

grant insert on table "public"."tags" to "anon";

grant references on table "public"."tags" to "anon";

grant select on table "public"."tags" to "anon";

grant trigger on table "public"."tags" to "anon";

grant truncate on table "public"."tags" to "anon";

grant update on table "public"."tags" to "anon";

grant delete on table "public"."tags" to "authenticated";

grant insert on table "public"."tags" to "authenticated";

grant references on table "public"."tags" to "authenticated";

grant select on table "public"."tags" to "authenticated";

grant trigger on table "public"."tags" to "authenticated";

grant truncate on table "public"."tags" to "authenticated";

grant update on table "public"."tags" to "authenticated";

grant delete on table "public"."tags" to "service_role";

grant insert on table "public"."tags" to "service_role";

grant references on table "public"."tags" to "service_role";

grant select on table "public"."tags" to "service_role";

grant trigger on table "public"."tags" to "service_role";

grant truncate on table "public"."tags" to "service_role";

grant update on table "public"."tags" to "service_role";

grant delete on table "public"."user_stats" to "anon";

grant insert on table "public"."user_stats" to "anon";

grant references on table "public"."user_stats" to "anon";

grant select on table "public"."user_stats" to "anon";

grant trigger on table "public"."user_stats" to "anon";

grant truncate on table "public"."user_stats" to "anon";

grant update on table "public"."user_stats" to "anon";

grant delete on table "public"."user_stats" to "authenticated";

grant insert on table "public"."user_stats" to "authenticated";

grant references on table "public"."user_stats" to "authenticated";

grant select on table "public"."user_stats" to "authenticated";

grant trigger on table "public"."user_stats" to "authenticated";

grant truncate on table "public"."user_stats" to "authenticated";

grant update on table "public"."user_stats" to "authenticated";

grant delete on table "public"."user_stats" to "service_role";

grant insert on table "public"."user_stats" to "service_role";

grant references on table "public"."user_stats" to "service_role";

grant select on table "public"."user_stats" to "service_role";

grant trigger on table "public"."user_stats" to "service_role";

grant truncate on table "public"."user_stats" to "service_role";

grant update on table "public"."user_stats" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

CREATE TRIGGER tg_daily_reactions_updated BEFORE UPDATE ON public.daily_reactions FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER tg_habit_records_updated BEFORE UPDATE ON public.habit_records FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER update_habit_statistics AFTER INSERT OR UPDATE ON public.habit_records FOR EACH ROW EXECUTE FUNCTION update_habit_stats();

CREATE TRIGGER update_user_statistics AFTER INSERT OR UPDATE ON public.habit_records FOR EACH ROW EXECUTE FUNCTION update_user_stats();

CREATE TRIGGER tg_habits_updated BEFORE UPDATE ON public.habits FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER update_habits_updated_at BEFORE UPDATE ON public.habits FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER tg_user_stats_updated BEFORE UPDATE ON public.user_stats FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER tg_users_updated BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


