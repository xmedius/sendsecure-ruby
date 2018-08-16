module SendSecure
  module ClientMethods
    module SafeboxMethods

      ###
      # Reply to a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      # @param reply: A reply object
      # @return A Hash containing request result
      ###
      def reply(safebox, reply)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid.nil?
        reply.attachments.each do |attachment|
          file_params = safebox.temporary_document(File.size(attachment.file_path))
          response = @json_client.initialize_file(safebox.guid, file_params.to_json)
          result = @json_client.upload_file(response["upload_url"], attachment.file_path || attachment.file, attachment.content_type, attachment.filename)
          reply.document_ids << result["temporary_document"]["document_guid"]
        end
        @json_client.reply(safebox.guid, reply.to_json)
      end

      ###
      # Add time to the expiration date of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #        value and unit: amount of time to be added to the expiration date
      # @return A Hash containing request result
      ###
      def add_time(safebox, value, time_unit)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        raise SendSecureException.new("Invalid time unit") unless SafeBox::TIME_UNIT.values.include?(time_unit)
        add_time_params = { "safebox": { "add_time_value": value, "add_time_unit": time_unit }}.to_json
        result = @json_client.add_time(safebox.guid, add_time_params)
        safebox.expiration = result.delete("new_expiration")
        result
      end

      ###
      # Close a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return A Hash containing request result
      ###
      def close_safebox(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.close_safebox(safebox.guid)
      end

      ###
      # Delete content of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return A Hash containing request result
      ###
      def delete_safebox_content(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.delete_safebox_content(safebox.guid)
      end

      ###
      # Mark all messages as read of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return A Hash containing request result
      ###
      def mark_as_read(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.mark_as_read(safebox.guid)
      end

      ###
      # Mark all messages as unread of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return A Hash containing request result
      ###
      def mark_as_unread(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.mark_as_unread(safebox.guid)
      end

      ###
      # Mark a message as read of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @param message: A Message object
      #
      # @return A Hash containing request result
      ###
      def mark_as_read_message(safebox, message)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid.nil?
        raise SendSecureException.new("Message cannot be null") if message.nil?
        @json_client.mark_as_read_message(safebox.guid, message.id)
      end

      ###
      # Mark a message as unread of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @param message: A Message object
      #
      # @return A Hash containing request result
      ###
      def mark_as_unread_message(safebox, message)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid.nil?
        raise SendSecureException.new("Message cannot be null") if message.nil?
        @json_client.mark_as_unread_message(safebox.guid, message.id)
      end

      ###
      # Retrieve the audit record of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return The audit record pdf stream
      ###
      def get_audit_record_pdf(safebox)
        url = get_audit_record_pdf_url(safebox)
        @json_client.get_audit_record_pdf(url)
      end

      ###
      # Retrieve the audit record url of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #
      # @return The audit record url
      ###
      def get_audit_record_pdf_url(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.get_audit_record_pdf_url(safebox.guid)["url"]
      end

      ###
      # Retrieve all info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #        sections: <string containing the list of sections to be retrieve>
      #
      # @return The updated Safebox
      ###
      def get_safebox_info(safebox, sections = nil)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        safebox.update_attributes(@json_client.get_safebox_info(safebox.guid, sections)["safebox"])
      end

      ###
      # Retrieve all participants info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #
      # @return The list of all participants of the safebox, with all their properties.
      ###
      def get_safebox_participants(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.get_safebox_participants(safebox.guid)["participants"].map {|p| Participant.new(p) }
      end

      ###
      # Retrieve all messages info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #
      # @return The list of all messages of the safebox, with all their properties.
      ###
      def get_safebox_messages(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.get_safebox_messages(safebox.guid)["messages"].map {|p| Message.new(p) }
      end

      ###
      # Retrieve all security options info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #
      # @return All values/properties of the security options.
      ###
      def get_safebox_security_options(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        SecurityOptions.new(@json_client.get_safebox_security_options(safebox.guid)["security_options"])
      end

      ###
      # Retrieve all download activity info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #
      # @return All values/properties of the download activity.
      ###
      def get_safebox_download_activity(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        DownloadActivity.new(@json_client.get_safebox_download_activity(safebox.guid)["download_activity"])
      end

      ###
      # Retrieve all event history info of an existing safebox for the current user account.
      #
      # @param safebox: A Safebox object
      #
      # @return The list of all event history of the safebox, with all their properties.
      ###
      def get_safebox_event_history(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        @json_client.get_safebox_event_history(safebox.guid)["event_history"].map {|p| EventHistory.new(p) }
      end

    end
  end
end