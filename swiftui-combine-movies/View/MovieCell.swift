//
//  MovieCell.swift
//  swiftui-combine-movies
//
//  Created by Andre Martingo on 06.06.19.
//  Copyright © 2019 Andre Martingo. All rights reserved.
//

import SwiftUI

struct MovieCell: View {
    
    @ObjectBinding var movie: MovieCellViewModel

    var body: some View {
        HStack {
            self.movie.image.map { image in
                Image(uiImage: image)
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.gray, lineWidth: 1))
                    .cornerRadius(5)
            }
            
            Text(movie.title)

        }
        .frame(height: 60)
    }
}
