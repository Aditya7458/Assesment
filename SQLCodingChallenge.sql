
CREATE DATABASE VirtualArtGallery;

USE VirtualArtGallery;

-- Create the Artists table

CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);

-- Create the Categories table

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Create the Artworks table

CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
);

-- Create the Exhibitions table

CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);

-- Create a table to associate artworks with exhibitions

CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
);

-- Insert sample data into the Artists table

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

select*from Artists;

-- Insert sample data into the Categories table

INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into the Artworks table

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');

select *from Artworks;

-- Insert sample data into the Exhibitions table

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions (junction table)

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),  
(1, 2),  
(1, 3),  
(2, 2);  


-- 1 Retrieve the names of all artists along with the number of artworks they have in the gallery, and 
--   list them in descending order of the number of artworks.

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
GROUP BY a.Name
ORDER BY ArtworkCount DESC;

-- 2 List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order 
--  them by the year in ascending order

SELECT art.Title
FROM Artworks art
JOIN Artists a ON art.ArtistID = a.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY art.Year ASC;

-- 3 Find the names of all artists who have artworks in the 'Painting' category, and the number of 
--   artworks they have in this category

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
JOIN Categories c ON art.CategoryID = c.CategoryID
WHERE c.Name = 'Painting'
GROUP BY a.Name;

-- 4 List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their 
--  artists and categories.

SELECT art.Title, a.Name AS ArtistName, c.Name AS CategoryName
FROM Artworks art
JOIN Artists a ON art.ArtistID = a.ArtistID
JOIN Categories c ON art.CategoryID = c.CategoryID
JOIN ExhibitionArtworks ea ON art.ArtworkID = ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces';

-- 5 Find the artists who have more than two artworks in the gallery.

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
GROUP BY a.Name
HAVING COUNT(art.ArtworkID) > 2;

-- 6 Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 
--  'Renaissance Art' exhibitions


SELECT art.Title
FROM Artworks art
JOIN ExhibitionArtworks ea1 ON art.ArtworkID = ea1.ArtworkID
JOIN Exhibitions e1 ON ea1.ExhibitionID = e1.ExhibitionID
JOIN ExhibitionArtworks ea2 ON art.ArtworkID = ea2.ArtworkID
JOIN Exhibitions e2 ON ea2.ExhibitionID = e2.ExhibitionID
WHERE e1.Title = 'Modern Art Masterpieces' 
  AND e2.Title = 'Renaissance Art';

-- 7 Find the total number of artworks in each category

SELECT c.Name AS CategoryName, COUNT(art.ArtworkID) AS TotalArtworks
FROM Categories c
JOIN Artworks art ON c.CategoryID = art.CategoryID
GROUP BY c.Name;

-- 8 List artists who have more than 3 artworks in the gallery.

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
GROUP BY a.Name
HAVING COUNT(art.ArtworkID) > 3;

-- 9 Find the artworks created by artists from a specific nationality (e.g., Spanish).

SELECT art.Title
FROM Artworks art
JOIN Artists a ON art.ArtistID = a.ArtistID
WHERE a.Nationality = 'Spanish';

-- 10 List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.

SELECT e.Title
FROM Exhibitions e
JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
JOIN Artworks art1 ON ea1.ArtworkID = art1.ArtworkID
JOIN Artists a1 ON art1.ArtistID = a1.ArtistID
JOIN ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
JOIN Artworks art2 ON ea2.ArtworkID = art2.ArtworkID
JOIN Artists a2 ON art2.ArtistID = a2.ArtistID
WHERE a1.Name = 'Vincent van Gogh' AND a2.Name = 'Leonardo da Vinci';

-- 11 Find all the artworks that have not been included in any exhibition.

SELECT art.Title
FROM Artworks art
LEFT JOIN ExhibitionArtworks ea ON art.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;

-- 12 List artists who have created artworks in all available categories

SELECT a.Name
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
JOIN Categories c ON art.CategoryID = c.CategoryID
GROUP BY a.Name
HAVING COUNT(DISTINCT art.CategoryID) = (SELECT COUNT(*) FROM Categories);

-- 13 List the total number of artworks in each category

SELECT c.Name AS CategoryName, COUNT(art.ArtworkID) AS TotalArtworks
FROM Categories c
JOIN Artworks art ON c.CategoryID = art.CategoryID
GROUP BY c.Name;

-- 14 Find the artists who have more than 2 artworks in the gallery.

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
GROUP BY a.Name
HAVING COUNT(art.ArtworkID) > 2;

-- 15 List the categories with the average year of artworks they contain, only for categories with more
--   than 1 artwork.

SELECT c.Name AS CategoryName, AVG(art.Year) AS AverageYear
FROM Categories c
JOIN Artworks art ON c.CategoryID = art.CategoryID
GROUP BY c.Name
HAVING COUNT(art.ArtworkID) > 1;

-- 16 Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.

SELECT art.Title
FROM Artworks art
JOIN ExhibitionArtworks ea ON art.ArtworkID = ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces';

-- 17 Find the categories where the average year of artworks is greater than the average year of all artworks

WITH AvgYearAll AS(SELECT AVG(Year) AS AvgYear FROM Artworks)
SELECT c.Name from Categories c
JOIN Artworks ar ON c.CategoryID=ar.CategoryID
GROUP BY c.Name
HAVING AVG(ar.Year)>(SELECT AvgYear FROM AvgYearAll);

-- 18 List the artworks that were not exhibited in any exhibition

SELECT art.Title
FROM Artworks art
LEFT JOIN ExhibitionArtworks ea ON art.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;

-- 19 Show artists who have artworks in the same category as "Mona Lisa."

SELECT a.Name
FROM Artists a
JOIN Artworks art1 ON a.ArtistID = art1.ArtistID
JOIN Artworks art2 ON art1.CategoryID = art2.CategoryID
WHERE art2.Title = 'Mona Lisa';
 
-- 20 List the names of artists and the number of artworks they have in the gallery

SELECT a.Name, COUNT(art.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks art ON a.ArtistID = art.ArtistID
GROUP BY a.Name
ORDER BY ArtworkCount DESC;
