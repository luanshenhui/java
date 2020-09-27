import React from 'react';
import PropTypes from 'prop-types';

import OrgAddress from './OrgAddress';

// 住所情報の入力フィールド
const OrgAddresses = (props) => (
  <div>
    {props.fields.map((address, index) => <OrgAddress {...props} key={`${address}`} index={index} address={address} />)}
  </div>
);

// propTypesの定義
OrgAddresses.propTypes = {
  fields: PropTypes.shape().isRequired,
};

export default OrgAddresses;

