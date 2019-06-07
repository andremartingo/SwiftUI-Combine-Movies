//
//  MovieCell.swift
//  swiftui-combine-movies
//
//  Created by Andre Martingo on 06.06.19.
//  Copyright © 2019 Andre Martingo. All rights reserved.
//

import SwiftUI

struct MovieCell: View {
    
    @EnvironmentObject var viewModel: SearchViewModel
    
    var movie: Movie

    var body: some View {
        HStack {
            self.viewModel.movieImages[movie].map { image in
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
        .onAppear { self.viewModel.getImage(for: self.movie) }
    }
}
