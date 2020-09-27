import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import moment from 'moment';
import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import Button from '../../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import LabelCourse from '../../../components/control/label/LabelCourse';
import * as Constants from '../../../constants/common';
import Label from '../../../components/control/Label';
import BulletedLabel from '../../../components/control/BulletedLabel';

import { getOrgListRequest, initializeOrgList } from '../../../modules/preference/organizationModule';

const WrapperBullet = styled.div`
  .bullet { color: #cc9999 };
`;

const CtrBrowseOrgHeader = (props) => {
  const { match } = props;
  return (
    <ListHeaderFormBase {...props} >
      <div>
        <FieldGroup itemWidth={90}>
          <FieldSet>
            <FieldItem>契約団体</FieldItem>
            <LabelOrgName orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} />
          </FieldSet>
          <FieldSet>
            <FieldItem>対象コース</FieldItem>
            <LabelCourse cscd={match.params.cscd} />
          </FieldSet>
          {match.params.opmode === Constants.OPMODE_COPY && (
            <FieldSet>
              <FieldItem>契約期間</FieldItem>
              <Label>{moment(match.params.strdate).format('YYYY年M月D日')}～{moment(match.params.enddate).format('YYYY年M月D日')}</Label>
            </FieldSet>
          )}
          <FieldSet>
            <WrapperBullet>
              <BulletedLabel>団体コードもしくは団体名称を入力して下さい。</BulletedLabel><span style={{ color: '#666666' }}>（対象コースの契約情報を持つ団体のみを検索します）</span>
            </WrapperBullet>
          </FieldSet>
          <FieldSet>
            <WrapperBullet>
              <BulletedLabel>一般団体から個人・Web予約の契約情報を参照する、またその逆は行うことはできません。</BulletedLabel>
            </WrapperBullet>
          </FieldSet>
        </FieldGroup>
      </div>
      <FieldSet>
        <Field name="keyword" component="input" type="text" style={{ width: 240 }} />
        <Button type="submit" value="検索" />
      </FieldSet>
    </ListHeaderFormBase>
  );
};

// propTypesの定義
CtrBrowseOrgHeader.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
};

const CtrBrowseOrgHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'CtrBrowseOrgHeader',
  enableReinitialize: true,
})(CtrBrowseOrgHeader);

const mapStateToProps = (state) => ({
  initialValues: {
    keyword: state.app.preference.organization.organizationList.conditions.keyword,
  },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  onSearch: (conditions) => {
    const [page, limit] = [1, 20];
    const { cscd } = props.match.params;
    dispatch(getOrgListRequest({ page, limit, ...conditions, cscd }));
  },
  initializeList: () => {
    dispatch(initializeOrgList());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrBrowseOrgHeaderForm));
