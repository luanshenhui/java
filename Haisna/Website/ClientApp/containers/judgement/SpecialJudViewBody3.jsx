import React from 'react';
import PropTypes from 'prop-types';
import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';

import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import EntitySpJudGuide from './EntitySpJudGuide';

const SpecialJudViewBody3 = ({ data, onOpenEntitySpJudGuide, rsvno }) => (
  <div>
    <div>
      <SectionBar title="階層化コメント" />
      <Button onClick={() => { onOpenEntitySpJudGuide({ rsvno }); }} value="対象者変更" />
    </div>
    <div>
      <FieldGroup itemWidth={110}>
        {data ?
          <FieldSet>
            <FieldItem>特定保健指導</FieldItem>
            {data === 1 &&
              <strong>対象外</strong>
            }
            {data === 2 &&
              <strong>対象</strong>
            }
          </FieldSet> : <div style={{ color: '#ff6600' }}><strong>現在、特定保健指導区分が登録されていません。</strong></div>
        }
      </FieldGroup>
    </div>
    <EntitySpJudGuide />
  </div >
);

// propTypesの定義
SpecialJudViewBody3.propTypes = {
  data: PropTypes.number,
  onOpenEntitySpJudGuide: PropTypes.func.isRequired,
  rsvno: PropTypes.string.isRequired,
};
// defaultPropsの定義
SpecialJudViewBody3.defaultProps = {
  data: null,
};

export default SpecialJudViewBody3;
