import React from 'react';

import Chip from '../components/Chip';

const PageExample = () => (
  <div>
    <Chip
      label="X線検査"
      onDelete={() => {
        // eslint-disable-next-line
        alert('Delete Buttonが押されました');
      }}
    />
  </div>
);

export default PageExample;
