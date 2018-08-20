module CommentsHelper
    def user_is_authorized_for_comment?(comment)
        current_user && (current_user == comment.user || current_user.admin?)
    end
    
    def user_has_existing_comments?
    end
end
