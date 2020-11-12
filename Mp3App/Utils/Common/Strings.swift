//
//  Strings.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct Strings {
    //common
    static let home = "Trang chủ"
    static let search = "Tìm kiếm"
    static let profile = "Cá nhân"
    static let settings = "Thiết lập"
    
    //login validate
    static let username = "Tài khoản"
    static let password = "Mật khẩu"
    static let usernameIsEmpty = "Vui lòng nhập tài khoản"
    static let passwordIsEmpty = "Vui lòng nhập mật khẩu"
    static let passwordIsInvalid = "Mật khẩu không đúng"
    static let passwordInRange = "Mật khẩu phải chứa từ %d đến %d ký tự"
    
    //home
    static let hiphop = "Hiphop - Rap"
    static let electronic = "Nhạc điện tử"
    static let classical = "Cổ điển"
    static let chart = "Bảng xếp hạng"
    static let singer = "Ca sĩ"
    static let rock = "Nhạc Rock"
    static let popular = "Phổ biến"
    
    //search
    static let searchPlaceholder = "Tìm kiếm bài hát, ca sĩ, playlist"
    static let track = "Bài hát"
    static let artist = "Nghệ sĩ"
    static let more = "Xem thêm"
    static let all = "Tất cả"
    static let history = "Lịch sử tìm kiếm"
    static let delete = "Xoá"
    static let confirm = "Đồng ý"
    static let cancel = "Huỷ"
    static let deleteSearchHistoryMessage = "Xoá lịch sử tìm kiếm?"
    
    //mypage
    static let library = "Thư viện"
    static let playlist = "Playlist"
    static let favouriteSong = "Bài hát yêu thích"
    static let createPlaylist = "Tạo playlist mới"
    
    //notification
    static let playlistCreatedNotification = "playlistCreatedNotification"
    static let playerNotification = "PlayerNotification"
    static let tracks = "tracks"
    static let selectedTrackItem = "selectedTrackItem"
    static let index = "index"
    static let changeTabSearch = "ChangeTabSearch"
    static let deleteSearchHistory = "deleteSearchHistory"
    static let ShowTrackOption = "ShowTrackOption"
    static let ShowPlaylistOption = "ShowPlaylistOption"
    
    //alert message
    static let sureToSignOut = "Bạn có chắc chắn muốn đăng xuất?"
    static let signOut = "Đăng xuất"
    static let yes = "Yes"
    static let no = "No"
    static let OK = "OK"
    static let removeTrackInFavourite = "Xoá khỏi danh sách yêu thích"
    static let addTrackToFavourite = "Thêm vào danh sách yêu thích"
    
    //format
    static let simpleDateFormat = "yyyy-MM-DD"
    static let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let emailFormat = "SELF MATCHES %@"
    
    //rotation
    static let rotationAnimationKey = "rotationanimationkey"
}
