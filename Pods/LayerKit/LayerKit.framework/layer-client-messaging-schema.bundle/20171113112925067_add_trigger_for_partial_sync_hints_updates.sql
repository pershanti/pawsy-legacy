-- Change the stream update trigger to create changes
-- even upon partial sync hints changes.
DROP TRIGGER track_updates_of_streams;

CREATE TRIGGER track_updates_of_streams AFTER UPDATE OF stream_id ON streams
WHEN (NEW.stream_id IS NOT NULL AND OLD.stream_id IS NULL) OR
     (NEW.total_message_event_count <> OLD.total_message_event_count) OR
     (NEW.unread_message_event_count <> OLD.unread_message_event_count)
BEGIN
  INSERT INTO synced_changes(
    stream_database_identifier,
    change_type,
    associated_stream_database_identifier)
  VALUES (
    NEW.database_identifier,
    1,
    NEW.database_identifier);
END;
