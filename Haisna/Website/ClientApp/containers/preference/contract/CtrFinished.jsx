import React from 'react';
import PropTypes from 'prop-types';
import PageLayout from '../../../layouts/PageLayout';
import SectionBar from '../../../components/SectionBar';
import Label from '../../../components/control/Label';
import Button from '../../../components/control/Button';

const CtrFinished = (props) => {
  const { history, match } = props;
  return (
    <PageLayout title="参照・コピー処理の完了">
      <SectionBar title="登録完了" />
      <div>
        <Button onClick={() => history.replace(`/contents/preference/contract/organization/${match.params.orgcd1}/${match.params.orgcd2}/courses`)} value="契約情報へ" />
      </div>
      <div>
        <Label>契約情報の参照・複写処理が完了しました。</Label>
      </div>
    </PageLayout>
  );
};

// propTypesの定義
CtrFinished.propTypes = {
  history: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  match: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default CtrFinished;
