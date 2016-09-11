/*************************************************************************
 *
 * REALM CONFIDENTIAL
 * __________________
 *
 *  [2011] - [2015] Realm Inc
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Realm Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Realm Incorporated
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Realm Incorporated.
 *
 **************************************************************************/
#ifndef REALM_LINK_VIEW_FWD_HPP
#define REALM_LINK_VIEW_FWD_HPP

#include <memory>

namespace realm {

class LinkView;
using LinkViewRef = std::shared_ptr<LinkView>;
using ConstLinkViewRef = std::shared_ptr<const LinkView>;

} // namespace realm

#endif // REALM_LINK_VIEW_FWD_HPP
