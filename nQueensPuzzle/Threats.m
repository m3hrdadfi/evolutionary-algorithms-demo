function num = Threats(nqueen, positions, queen)
    other_queens = queen+1:nqueen;
    other_queen_positions = positions(other_queens);

    y1 = (positions(queen) - queen) + other_queens;
    y2 = (positions(queen) + queen) - other_queens;
    
    num = sum(other_queen_positions == y1) + sum(other_queen_positions == y2);
end