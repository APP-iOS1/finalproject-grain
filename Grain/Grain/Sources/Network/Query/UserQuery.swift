//
//  UserQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

enum UserQuery {
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertUserQuery(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> Data? {
  
        return
        """
        {
        "fields": {
                        "myFilm": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(myFilm)"
                                    }
                                ]
                            }
                        },
                        "bookmarkedMagazineID": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(bookmarkedMagazineID)"
                                    }
                                    
                                ]
                            }
                        },
                        "email": {
                            "stringValue": "\(email)"
                        },
                        "myCamera": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(myCamera)"
                                    }
                                ]
                            }
                        },
                        "postedCommunityID": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(postedCommunityID)"
                                    }
                                ]
                            }
                        },
                        "postedMagazineID": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(postedMagazineID)"
                                    }
                                ]
                            }
                        },
                        "likedMagazineId": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(likedMagazineId)"
                                    }
                                ]
                            }
                        },
                        "lastSearched": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(lastSearched)"
                                    }
                                ]
                            }
                        },
                        "bookmarkedCommunityID": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(bookmarkedCommunityID)"
                                    }
                                ]
                            }
                        },
                        "recentSearch": {
                            "stringValue": "\(recentSearch)"
                        },
                        "id": {
                            "stringValue": "\(id)"
                        },
                        "following": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(following)"
                                    }
                                ]
                            }
                        },
                        "myLens": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(myLens)"
                                    }
                                ]

                            }
                        },
                        "profileImage": {
                            "stringValue": "\(profileImage)"
                        },
                        "name": {
                            "stringValue": "\(name)"
                        },
                        "follower": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(follower)"
                                    }
                                ]
                            }
                        },
                        "nickName": {
                            "stringValue": "\(nickName)"
                        }
                    }
                }
        }
        """.data(using: .utf8)
    }
}
