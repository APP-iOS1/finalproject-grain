//
//  UserQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

enum UserQuery {
    
    // MARK: 최초로 로그인시 사용
    static func insertUserQuery(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> Data? {

        return
        
        """
         {
                            "fields": {
                
                                "follower": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(follower)"
                                            }
                                        ]
                                    }
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
                                "profileImage": {
                                    "stringValue": "\(profileImage)"
                                },
                                "email": {
                                    "stringValue": "\(email)"
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
                                "name": {
                                    "stringValue": "\(name)"
                                },
                                "id": {
                                    "stringValue":  "\(id)"
                                },
                                "nickName": {
                                    "stringValue": "\(nickName)"
                                },
                                "recentSearch": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                    "stringValue": "\(recentSearch)"
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
                                "myLens": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(myLens)"
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
                                "postedMagazineID": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(postedMagazineID)"
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
                                "lastSearched": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(lastSearched)"
                                            }
                                        ]
                                    }
                                },
                                "myFilm": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(myFilm)"
                                            }
                                        ]
                                    }
                                },
                                "following": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(following)"
                                            }
                                        ]
                                    }
                                }
                            }
         }
                        
        """.data(using: .utf8)
    }
}
