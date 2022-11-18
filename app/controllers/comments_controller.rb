# frozen_string_literal: true
class CommentsController < ApplicationController
  include CommentsUserDetailsLoader
  include SuggestionsProvider

  before_action :authenticate_user!, except: [:index, :answers]
  suggestions on: :index, includes: [:screen]

  def index
    @comments = game.comments.roots.latest
                    .includes(:user).page(params[:page])
    render layout: pjax_request? ? nil : 'game'
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.assign_attributes(
      user: current_user,
      game: game
    )

    respond_to do |format|
      if @comment.save
        @comments_count = game.comments.roots.count
        CommentsService.new().created!(@comment)
      else
        # Ensure we log the error, if there is one.
        Rails.logger.error(@comment.errors.full_messages.to_sentence) if Rails.env.development?
      end
      format.html { redirect_to (request.referrer || root_path) }
      format.js
    end
  end

  def answers
    @comments = comment.children.latest
                       .includes(:user, :game).page(params[:page])
    @first_page = (params[:page] || 1).to_i <= 1
    render layout: false
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    authorize(comment)

    respond_to do |format|
      if comment.destroy
        format.html { redirect_to(game_comments_path(game.slug)) }
        format.js do
          @comments_count = comment.game.comments.roots.count
        end

        CommentsService.new().destroyed!(comment)
      else
        format.html do
          flash[:error] = t('.destroy_failure')
          redirect_to(game_comments_path(game.slug))
        end
      end
    end
  end

private

  def game
    @game ||= Game.find(params[:game_id]).decorate
  end

  # Use callbacks to share common setup or constraints between actions.
  def comment
    @comment ||= Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def comment_params
    params.require(:comment).permit(:comment_id, :text)
  end
end
