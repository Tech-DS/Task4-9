class BooksController < ApplicationController
  
before_action :authenticate_user!
before_action :ensure_current_user, {only: [:edit,:update,:destroy]}


 def create
    @user = current_user
    @book = Book.new(book_params)
    @book.user_id = (current_user.id)
  if @book.save
     flash[:notice] = "You have creatad book successfully."
     @books = Book.all
     redirect_to "/books/#{@book.id}"
  else
     @books = Book.all
     flash[:notice] = ' errors prohibited this obj from being saved:'
     render "index"
  end
 end
 
 def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
 end
 
 def index
    @user = current_user
    @books = Book.all
    @book = Book.new
 end
 
 def edit
    @book = Book.find(params[:id])
 end
 
 def update
    @book = Book.find(params[:id])
  if @book.update(book_params)
     flash[:notice] = "Book was successfully updated."
     redirect_to  book_path(@book.id)
  else
     @books = Book.all
     render "edit"
  end
 end
 
 def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:success] = "Book was successfully destroyed."
    redirect_to("/books")
 end

 private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end
  def ensure_current_user
      @book = Book.find(params[:id])
   if @book.user_id != current_user.id
      redirect_to books_path
   end
  end

end