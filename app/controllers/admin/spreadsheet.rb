require 'bundler'
Bundler.require

class SpreadsheetSession
    def initialize(title)
        @title = title
        # Authenticate a session with your Service Account
        session = GoogleDrive::Session.from_config("client_secret.json")
        # Get the spreadsheet by its title
        @spreadsheet = session.create_spreadsheet(@title)
        # Get the first worksheet
        #@worksheet = @spreadsheet.worksheets[0]
        #worksheet.insert_rows(worksheet.num_rows + 1, [["New", "Worksheet"]])
        #@worksheet.save

    end

    def fileid()
        @file_id = @spreadsheet.worksheets_feed_url.split("/")[-3]
    end

    def share_file(real_user)
      ids = []
      callback = lambda do |res, err|
        if err
          # Handle error...
          puts err.body
        else
          puts "Permission ID: #{res.id}"
          # [START_EXCLUDE silent]
          ids << res.id
          # [END_EXCLUDE]
        end
      end
      user_permission = {
          type: 'user',
          role: 'writer',
          email_address: 'karadelamarck@gmail.com'
      }
      # [START_EXCLUDE silent]
      # user_permission[:email_address] = real_user
      # [END_EXCLUDE]

    @spreadsheet.acl.push(user_permission)
      # @spreadsheet.create_permission(file_id,
      #                           user_permission,
      #                           fields: 'id',
      #                           &callback)
    return ids
  end


    def add_student(student)

        @worksheet.insert_rows(worksheet.num_rows + 1, [["#{student.full_name}", " ", " ", " " "#{student.about_you}"]])

        worksheet.save
    end
end

##Note: the above code works, so this is quite functional! :)
#However, many outstanding issues to bring this to production.
#Need to give permission to view and edit to workshop organisers once create the spreadsheet.
#Also, all secrets in the client_secret.json belong to my Google account.
