import React from 'react';
import PropTypes from 'prop-types';
import PersonAddress from './PersonAddress';

// 住所情報の入力フィールド
const PersonAddresses = (props) => (
  <div>
    {props.fields.map((address, index) => <PersonAddress {...props} key={address} index={index} address={address} />)}

  </div>
);
// propTypesの定義
PersonAddresses.propTypes = {
  fields: PropTypes.shape().isRequired,
};

export default PersonAddresses;

