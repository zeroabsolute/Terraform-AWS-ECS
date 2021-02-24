import React, { useEffect, useState } from 'react';
import Axios from 'axios';
import './App.css';
import config from './config';

function App() {
  const [books, setBooks] = useState([]);
  const [newBook, setNewBook] = useState([]);

  useEffect(() => {
    readAndShowBooks(setBooks);
  }, []);

  return (
    <div className="App">
      {
        renderAddBookForm(
          newBook,
          setNewBook,
          addBook,
          () => readAndShowBooks(setBooks)
        )
      }
      <div className="books-container">
        {renderBooksList(books)}
      </div>
    </div>
  );
}

function renderAddBookForm(newBook, setNewBook, addBookHandler, readBooksHandler) {
  return (
    <div className="books-add">
      <input
        type="text"
        onChange={(e) => setNewBook(e.target.value)}
      />
      <button onClick={async () => {
        await addBookHandler(newBook);
        readBooksHandler();
      }}>
        Save
      </button>
    </div>
  );
}

function renderBooksList(booksState) {
  return booksState.map((book, index) => (
    <div key={`Book-${index}`} className="books-item">
      <span>{book.title}</span>
    </div>
  ));
}

async function readAndShowBooks(setBooks) {
  const booksFromAPI = await getBooks();
  setBooks(booksFromAPI);
}

async function getBooks() {
  try {
    const result = await Axios.get(`${config.SERVER_URL}/books`);
    return result.data;
  } catch (e) {
    console.log(e);
    return [];
  }
}

async function addBook(title) {
  try {
    const body = { title };
    const result = await Axios.post(`${config.SERVER_URL}/books`, body);
    return result.data;
  } catch (e) {
    console.log(e);
    return null;
  }
}

export default App;
