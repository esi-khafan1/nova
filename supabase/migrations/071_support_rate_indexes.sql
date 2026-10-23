create index support_threads_creation_rate on private.support_threads(created_at);
create index support_messages_visitor_rate on private.support_messages(thread_id,sender,created_at);
